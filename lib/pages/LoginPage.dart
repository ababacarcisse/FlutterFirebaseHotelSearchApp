import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Screen.dart';
import 'authService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool inLoginProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/lg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Login Pour les taxis',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Vous n'avez pas de temps à perde. Des Clients vous attends"
                  " . Connexion Simple et Rapide ",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              inLoginProcess
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      child: const Text("Connectez-vous avec Google"),
                      onPressed: () => signIn(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    if (kIsWeb) {
      setState(() {
        inLoginProcess = true;
        AuthService().signInWithGoogleAsTaxi(context);
      });
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            inLoginProcess = true;
          });
          await AuthService().signInWithGoogleAsTaxi(
              context); // Appel synchrone à signInWithGoogle après l'achèvement du travail asynchrone
        }
      } on SocketException catch (_) {
        showNotification(context, 'Aucune connexion internet');
      }
    }
  }
}
