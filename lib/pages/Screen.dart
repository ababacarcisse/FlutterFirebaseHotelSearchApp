import 'package:flutter/material.dart';
import 'package:sugnu_taxi/pages/LoginPage.dart';

import 'loginUserPage.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 500,
      width: 700,
      child: Center(
        child: Column(children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text("Chauffeur")),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginUserpage()));
              },
              child: const Text("User")),
        ]),
      ),
    );
  }
}

void showNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
