import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../Model/order.dart';
import '../Model/taxi.dart';

class DatabaseService {
  String? userID, taxiID;
  DatabaseService({this.userID, this.taxiID});
  // Déclaraction et Initialisation
  CollectionReference _taxi = FirebaseFirestore.instance.collection('taxi');
  FirebaseStorage _storage = FirebaseStorage.instance;
  final _commandsCollection = FirebaseFirestore.instance.collection('commands');

  //Commender un taxi
  Future<void> addCommand(Command command) async {
    final collection = FirebaseFirestore.instance.collection('commands');
    LatLng initialPosition = await _getCurrentPosition();

    final docRef = await collection.add({
      'taxiUserID': command.taxiID,
      'clientID': command.customerID,
      'clientName': command.clientName,
      'date': command.timestamp,
      'carName': command.TaxiName,
      "status": command.status,
      "destination": command.destination,
      "location": {
        'latitude': initialPosition.latitude,
        'longitude': initialPosition.longitude,
      }
    });
    command.commandID = docRef.id;
    await docRef.update({'commandID': command.commandID});
  }

//annuler une commande
  Future<void> deleteCommand(String commandId) async {
    final DocumentReference<Map<String, dynamic>> commandRef =
        _commandsCollection.doc(commandId);
    return commandRef.delete();
  }

  // upload de l'image vers Firebase Storage
  Future<String> uploadFile(File file, XFile fileWeb) async {
    Reference reference = _storage.ref().child('taxi/${DateTime.now()}.png');
    Uint8List imageTosave = await fileWeb.readAsBytes();
    SettableMetadata metaData = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = kIsWeb
        ? reference.putData(imageTosave, metaData)
        : reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<LatLng> _getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
  // une fonction  retourne
  //un booléen indiquant si le service de localisation est activé et si l'application a la permission d'accéder à la localisation de l'utilisateur :

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Service de localisation désactivé, afficher un message d'erreur ou retourner simplement
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Demander la permission de localisation à l'utilisateur
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Permission refusée, afficher un message d'erreur ou retourner simplement
        return false;
      }
    }

    // Si nous sommes arrivés jusqu'ici, le service de localisation est activé et l'application a la permission d'accéder à la localisation de l'utilisateur
    return true;
  }

  void addCar(Taxi taxi) async {
    bool isLocationEnabled = await checkLocationPermission();
    if (!isLocationEnabled) {
      // La localisation n'est pas activée ou la permission a été refusée, afficher un message d'erreur ou retourner simplement
      return;
    }

    LatLng initialPosition = await _getCurrentPosition();

    _taxi.add({
      "carName": taxi.taxiName,
      "taxiUrlImg": taxi.taxiUrlImg,
      "taxiUserID": taxi.taxiUserID,
      "taxiUserName": taxi.taxiUserName,
      'location': {
        'latitude': initialPosition.latitude,
        'longitude': initialPosition.longitude,
      },
      "taxiTimestamp": FieldValue.serverTimestamp(),
    });
  }

  // suppression de la voiture
  Future<void> deleteCar(String taxiID) => _taxi.doc(taxiID).delete();
//récupere les taxi les plus proches
  Stream<List<Taxi>> get taxis {
    Query querytaxi = _taxi.orderBy('taxiTimestamp', descending: true);
    return querytaxi.snapshots().asyncMap((snapshot) async {
      List<Taxi> taxis = [];
      for (var doc in snapshot.docs) {
        LatLng initialPosition = await _getCurrentPosition();
        Taxi taxi = Taxi(
          taxiID: doc.id,
          taxiName: doc.get('taxiName'),
          taxiUrlImg: doc.get('taxiUrlImg'),
          taxiUserID: doc.get('taxiUserID'),
          taxiUserName: doc.get('taxiUserName'),
          taxiTimestamp: doc.get('taxiTimestamp'),
          initialPosition: initialPosition,
        );
        taxis.add(taxi);
      }
      return taxis;
    });
  }

  Future<Taxi> singleTaxi(String taxiID) async {
    final doc = await _taxi.doc(taxiID).get();
    return Taxi(
      taxiID: taxiID,
      taxiName: doc.get('taxiName'),
      taxiUrlImg: doc.get('taxiUrlImg'),
      taxiUserID: doc.get('taxiUserID'),
      taxiUserName: doc.get('taxiUserName'),
      taxiTimestamp: doc.get('taxiTimestamp'),
      initialPosition: doc.get("location"),
    );
  }
}
