import 'package:flutter/material.dart';
import 'package:travel_app/Function/function.dart';
import 'package:travel_app/pages/LoginPage.dart';

import 'MoteurSearchPage.dart';

class ScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              const Color.fromARGB(255, 20, 81, 132),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Action pour le premier bouton
                  navigateTo(context, const HotelSearchPage());
                },
                child: const Text(
                  'Touriste',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Action pour le deuxième bouton
                  navigateTo(context, const LoginPage());
                },
                child: const Text(
                  'Hotels',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
