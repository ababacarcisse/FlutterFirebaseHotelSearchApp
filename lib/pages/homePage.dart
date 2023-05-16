import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sugnu_taxi/pages/authService.dart';
import 'package:sugnu_taxi/pages/taxinearby.dart';

import 'MyOrderTaxisPage.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  List<Marker>? _markers = [];
  final TextEditingController _destinationController = TextEditingController();
  String? _selectedTransport;
  CollectionReference? _taxiCollectionRef;
  AuthService authService = AuthService();
  List<QueryDocumentSnapshot> _nearestTaxis = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.yellow,
        automaticallyImplyLeading: false, // Supprime l'icône de retour
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<LatLng>(
              future: _getCurrentPosition(),
              builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentPosition = snapshot.data!;
                return SizedBox(
                  height: 450,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: Set<Marker>.of(_markers!),
                    initialCameraPosition: CameraPosition(
                      target: currentPosition,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Commande du taxi avec la destination
                        var currentPositionss = _getCurrentPosition();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaxisPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Text('commander '),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        // Mes commandes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyOrderTaxisPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Text(' Commandes'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () {
                AuthService authService = AuthService();
                authService.signOut();
                print("cliquer");
              },
              child: const Text("Déconnexion"),
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

  Future<LatLng> _getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }

//obtenir les taxi les proche
}
