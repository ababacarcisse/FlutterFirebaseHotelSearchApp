import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final LatLng clientLocation;
  final LatLng taxiLocation;

  const MapPage({
    super.key,
    required this.clientLocation,
    required this.taxiLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Créez une liste de points pour la polyline
    final List<LatLng> points = [clientLocation, taxiLocation];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trajet'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: clientLocation,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('client'),
            position: clientLocation,
          ),
          Marker(
            markerId: const MarkerId('taxi'),
            position: taxiLocation,
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
