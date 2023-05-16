import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sugnu_taxi/pages/MyAskTaxiPage.dart';

import '../service.dart/Service.dart';
import '../widget/MapsTrajetPage.dart';
import 'authService.dart';

class MapDriverPage extends StatefulWidget {
  const MapDriverPage({Key? key}) : super(key: key);

  @override
  _MapDriverPageState createState() => _MapDriverPageState();
}

class _MapDriverPageState extends State<MapDriverPage> {
  GoogleMapController? _mapController;
  List<Marker>? _markers = [];
  final TextEditingController _destinationController = TextEditingController();
  String? _selectedTransport;
  CollectionReference? _taxiCollectionRef;
  AuthService authService = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _taxiCollectionRef = FirebaseFirestore.instance.collection('taxi');
  }

  @override
  Widget build(BuildContext context) {
    Future<LatLng> _getCurrentPosition() async {
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false, // Supprime l'icône de retour
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //afficher le popup pour accepter ou refuser la commande
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('commands')
                    .where('taxiUserID', isEqualTo: currentUser.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final document = snapshot.data!.docs[index];
                      final data = document.data() as Map<String, dynamic>;
                      final clientName = data['clientName'] as String?;
                      final destination = data['destination'] as String?;
                      final clientLocation = data['location'];
                      final clientLatitude = clientLocation['latitude'];
                      final clientLongitude = clientLocation['longitude'];
                      final timestamp = data['date'] as Timestamp?;
                      final commandID = document.id;

                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Commande',
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client: $clientName',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      'destination: ${destination ?? ''}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            LatLng initialPosition =
                                                await _getCurrentPosition();

                                            // Ajouter ici la logique de validation de commande
                                            await FirebaseFirestore.instance
                                                .collection('commands')
                                                .doc(commandID)
                                                .update({'status': 'validé'});
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MapPage(
                                                  clientLocation: LatLng(
                                                      clientLatitude,
                                                      clientLongitude),
                                                  taxiLocation: LatLng(
                                                      initialPosition.latitude,
                                                      initialPosition
                                                          .longitude),
                                                ),
                                              ),
                                            );
                                            return;
                                          },
                                          child: const Text(
                                            'Valider',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await DatabaseService()
                                                .deleteCommand(commandID);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Refuser',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(
                            clientName ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            timestamp?.toDate().toString() ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Mes commandes

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAskTaxisPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50), // Taille du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordure arrondie
                      ),
                    ),
                    child: const Text('Mes Demandes'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Mes commandes

                        var out = await authService.signOut();
                        return out;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50), // Taille du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Bordure arrondie
                        ),
                      ),
                      child: const Text('Déconnexion '),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }
}
