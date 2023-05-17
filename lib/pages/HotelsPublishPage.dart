import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/Function/function.dart';

import 'adminPanelPage.dart';

class HotelPublishPage extends StatefulWidget {
  const HotelPublishPage({super.key});

  @override
  _HotelPublishPageState createState() => _HotelPublishPageState();
}

class _HotelPublishPageState extends State<HotelPublishPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pnoneController = TextEditingController();
  final TextEditingController _descriptionControlller = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  TextEditingController _destinationController =
      TextEditingController(text: 'Dakar');

  File? _selectedImage;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  void _publishHotel() async {
    try {
      String imageURL = '';

      if (_selectedImage != null) {
        // Uploading image to Firebase Storage
        TaskSnapshot snapshot = await _storage
            .ref('hotel_images/${_selectedImage?.path.split('/').last}')
            .putFile(_selectedImage!);
        imageURL = await snapshot.ref.getDownloadURL();
      }

      await _firestore.collection('hotels').add({
        'name': _nameController.text,
        'phone': _pnoneController.text,
        'price': _priceController
            .text, // Utilisation de _priceController.text au lieu de _priceController
        'destination': _destinationController.text,
        'description': _descriptionControlller.text,

        'imageURL': imageURL,
      });
      navigateTo(context, AdminPanelPage());
      // Hotel published successfully, you can perform additional actions here
      print('Hotel published successfully');
    } catch (e) {
      // Handling errors when publishing the hotel
      print('Error publishing hotel: $e');
    }
  }

  //obtenir l'image
  Future<File?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    _selectedImage = await showDialog<File?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () async {
                final image = await picker.pickImage(
                  source: ImageSource.camera,
                );
                Navigator.of(context)
                    .pop(image?.path != null ? File(image!.path) : null);
              },
              icon: Icon(Icons.camera),
              label: Text('Appareil photo'),
            ),
            TextButton.icon(
              onPressed: () async {
                final image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                Navigator.of(context)
                    .pop(image?.path != null ? File(image!.path) : null);
              },
              icon: Icon(Icons.image),
              label: Text('Galerie'),
            ),
          ],
        ),
      ),
    );
    return _selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Hotel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hotel Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Price Nuité',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              TextField(
                controller: _pnoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              TextField(
                controller: _descriptionControlller,
                maxLength: 100,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Entrez une description (100 caractères max)',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _destinationController.text,
                onChanged: (value) {
                  setState(() {
                    _destinationController.text = value!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text(''),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Dakar',
                    child: Text('Dakar'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Saint Louis',
                    child: Text('Saint Louis'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Fatick',
                    child: Text('Fatick'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Thies',
                    child: Text('Thies'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  pickImage(context);
                },
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 16.0),
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 200.0,
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _publishHotel();
                },
                child: const Text('Publier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
