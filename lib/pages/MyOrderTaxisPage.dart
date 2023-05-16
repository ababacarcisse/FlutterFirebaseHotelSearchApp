import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugnu_taxi/Model/order.dart';

import '../service.dart/Service.dart';

class MyOrderTaxisPage extends StatefulWidget {
  const MyOrderTaxisPage({Key? key});

  @override
  State<MyOrderTaxisPage> createState() => _MyOrderTaxisPageState();
}

class _MyOrderTaxisPageState extends State<MyOrderTaxisPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _commandsCollection = FirebaseFirestore.instance.collection('commands');
  List<Command> orders = [];

  @override
  Widget build(BuildContext context) {
    Future<void> deleteCommand(String commandID) async {
      try {
        await _commandsCollection.doc(commandID).delete();
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mes commandes de taxi'),
        backgroundColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('commands')
            .where('clientID', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'Une erreur est survenue',
              style: TextStyle(color: Colors.white),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text(
                'Vous n\'avez pas encore de commande.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data() as Map<String, dynamic>;
              final taxiName = data['carName'] as String?;
              final timestamp = data['date'] as Timestamp?;
              final status = data['status'] as String?;

              final commandID = document.id;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(15.0),
                child: ListTile(
                  title: Text(
                    taxiName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    status ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Ajoutez ici la logique pour l'appel téléphonique
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await DatabaseService().deleteCommand(commandID);
                          setState(() {
                            orders.remove(commandID);
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            timestamp?.toDate().toString() ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.yellow,
                          content: const Text(
                            'Votre commande a été envoyée !',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
