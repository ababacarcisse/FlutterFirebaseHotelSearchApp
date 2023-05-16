import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugnu_taxi/Model/order.dart';

import '../service.dart/Service.dart';

class MyAskTaxisPage extends StatefulWidget {
  const MyAskTaxisPage({
    super.key,
  });

  @override
  State<MyAskTaxisPage> createState() => _MyAskTaxisPageState();
}

class _MyAskTaxisPageState extends State<MyAskTaxisPage> {
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
        title: const Text('Mes Demandes de client'),
        backgroundColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('commands')
            .where('taxiUserID', isEqualTo: currentUser?.uid)
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
              final clientName = data['clientName'] as String?;
              final timestamp = data['date'] as Timestamp?;
              final status = data['status'] as String?;
              final commandID = document.id;

              return ListTile(
                title: Text(
                  clientName ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  status ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(status ?? ''),
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
                      icon: Icon(
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
