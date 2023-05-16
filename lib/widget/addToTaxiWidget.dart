import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugnu_taxi/widget/showDialog.dart';

import '../pages/MapsDriverPage.dart';
import '../pages/authService.dart';

class AddToTaxiSectionWidget extends StatefulWidget {
  User? user;

  AddToTaxiSectionWidget({super.key, required this.user});

  @override
  State<AddToTaxiSectionWidget> createState() => _AddToTaxiSectionWidgetState();
}

class _AddToTaxiSectionWidgetState extends State<AddToTaxiSectionWidget> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Salut'),
                        Text(user!.displayName.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                          child: IconButton(
                            onPressed: () => showCarDialog(context, user),
                            icon: Icon(Icons.add),
                            tooltip: 'Ajouter votre taxi',
                          ),
                        )
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      AuthService authService = AuthService();
                      authService.signOut();
                      print("cliquer");
                    },
                    child: const Text("déconnexion")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapDriverPage()));
                    },
                    child: const Text("home"))
              ],
            ),
          )
        ],
      ),
    );
  }

  void showCarDialog(BuildContext context, User user) async {
    if (kIsWeb) {
      TaxiDialog(user: user).showCarDialog(context, ImageSource.gallery);
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          TaxiDialog(user: user).showCarDialog(context, ImageSource.gallery);
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => MapDriverPage())));
        }
      } on SocketException catch (_) {
        //  showNotification(context, 'Aucune connexion internet');
      }
    }
  }
}
