import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sugnu_taxi/pages/pageInfo.dart';

import 'homePage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Connexion avec le Google du client
  Future<UserCredential> signInWithGoogleAsClient(BuildContext context) async {
    if (kIsWeb) return await _auth.signInWithPopup(googleProvider);

    // Déclencher le flux d'authentification
    final googleUser = await _googleSignIn.signIn();

    // obtenir les détails d'autorisation de la demande
    final googleAuth = await googleUser!.authentication;

    // créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // une fois connecté, renvoyez l'identifiant de l'utilisateur
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Naviguer vers la page MapPage
    if (userCredential != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapPage(),
        ),
      );
    }

    return userCredential;
  }

//pour le taxi
  Future<UserCredential> signInWithGoogleAsTaxi(BuildContext context) async {
    if (kIsWeb) return await _auth.signInWithPopup(googleProvider);

    // Déclencher le flux d'authentification
    final googleUser = await _googleSignIn.signIn();

    // obtenir les détails d'autorisation de la demande
    final googleAuth = await googleUser!.authentication;

    // créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // une fois connecté, renvoyez l'identifiant de l'utilisateur
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Naviguer vers la page PageInfo
    if (userCredential != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageInfo(),
        ),
      );
    }

    return userCredential;
  }

  // l'état de l'utilisateur en temps réel
  Stream<User?> get user => _auth.authStateChanges();

  // déconnexion
  Future<void> signOut() async {
    _googleSignIn.signOut();
    return _auth.signOut();
  }
}
