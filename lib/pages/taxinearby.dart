import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sugnu_taxi/service.dart/mapService.dart';
import 'package:uuid/uuid.dart';

import '../Model/order.dart';
import '../service.dart/Service.dart';

class TaxisPage extends StatelessWidget {
  const TaxisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Taxis'),
        backgroundColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('taxi').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              print(data);
              final carName =
                  data['carName'] != null ? data['carName'] as String : '';
              //     final taxiUserName = data['taxiUserName'] as String;
              final taxiUrlImg = data['taxiUrlImg'] as String;
              return ListTile(
                title: Text(
                  carName,
                  style: const TextStyle(color: Colors.white),
                ),
                //    subtitle: Text(taxiUserName),
                onTap: () async {
                  // Taxi? taxi;
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final taxiId = data['taxiUserID'] != null
                      ? data['taxiUserID'] as String
                      : '';
                  MapService mapService = MapService();
                  final carName =
                      data['carName'] != null ? data['carName'] as String : '';

                  final command = Command(
                    taxiID: taxiId,
                    clientName: currentUser!.displayName.toString(),
                    customerID: currentUser.uid,
                    timestamp: DateTime.now(),
                    TaxiName: carName,
                    destination: 'Touba',
                    commandID: Uuid().v4(),
                  );
                  await DatabaseService().addCommand(command);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Commande envoyée',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.yellow,
                        content: Text(
                          'Votre commande a été envoyée avec succès!',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
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

                leading: CircleAvatar(
                  backgroundImage: NetworkImage(taxiUrlImg),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
