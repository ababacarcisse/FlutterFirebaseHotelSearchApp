import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/taxi.dart';
import '../service.dart/Service.dart';

class TaxiDialog {
  User? user;
  TaxiDialog({this.user});

  // pour visualiser la boite de dialogue
  void showCarDialog(BuildContext context, ImageSource source) async {
    XFile? _pickedFile = await ImagePicker().pickImage(source: source);
    File _file = File(_pickedFile!.path);
    final _keyForm = GlobalKey<FormState>();
    String _taxiName = '';
    String _formError = 'Veillez fournir le nom de votre taxi svp!';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final mobilHeight = MediaQuery.of(context).size.height * 0.25;
          final webHeight = MediaQuery.of(context).size.height * 0.5;
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            children: [
              Container(
                height: kIsWeb ? webHeight : mobilHeight,
                margin: EdgeInsets.all(8.0),
                color: Colors.grey,
                child: kIsWeb
                    ? Image(
                        image: NetworkImage(_file.path),
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: FileImage(_file),
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: _keyForm,
                      child: TextFormField(
                        maxLength: 20,
                        onChanged: (value) => _taxiName = value,
                        validator: (value) =>
                            _taxiName == '' ? _formError : null,
                        decoration: InputDecoration(
                          labelText: 'Nom du taxi ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('ANNULER'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => onSubmit(context, _keyForm, _file,
                                _pickedFile, _taxiName, user),
                            child: Text('PUBLIER'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Future<LatLng> _getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  void onSubmit(context, keyForm, file, fileWeb, taxiName, user) async {
    if (keyForm.currentState!.validate()) {
      Navigator.of(context).pop();
      try {
        DatabaseService db = DatabaseService();
        String _taxiUrlImg = await db.uploadFile(file, fileWeb);
        LatLng initialPosition = await _getCurrentPosition();

        db.addCar(
          Taxi(
              taxiName: taxiName,
              taxiUrlImg: _taxiUrlImg,
              taxiUserID: user!.uid,
              taxiUserName: user!.displayName,
              taxiID: '',
              taxiTimestamp: null,
              initialPosition: initialPosition),
        );
      } catch (error) {
        print("Erreur $error");
      }
    }
  }
}
