import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/Function/function.dart';
import 'package:travel_app/pages/detail_page.dart';

import '../misc/colors.dart';
import '../widgets/itemCard.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({Key? key}) : super(key: key);

  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  TextEditingController destinationController = TextEditingController();

  List<QueryDocumentSnapshot> filteredHotels =
      []; // Liste pour stocker les hôtels filtrés
  bool isLoading = false; // État de chargement

  void searchHotels() async {
    String destination = destinationController.text;
    final _firestore = FirebaseFirestore.instance;
    // Effectuer la requête sur Firebase Firestore pour obtenir les hôtels ayant la même destination
    setState(() {
      isLoading = true; // Début du chargement
    });
    QuerySnapshot querySnapshot = await _firestore
        .collection('hotels')
        .where('destination', isEqualTo: destination)
        .get();

    // Mettre à jour la liste des hôtels filtrés avec les résultats de la requête
    setState(() {
      isLoading = false; // Fin du chargement
      filteredHotels = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor1,
        title: const Text(
          'Moteur de recherche d\'hôtels',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Un Moteur de recherche puissant pour trouver des Hôtels de Votre Destination",
            ),
            const SizedBox(height: 30),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                searchHotels();
              },
              child: const Text('Rechercher'),
            ),
            const SizedBox(height: 16.0),
            if (isLoading)
              const CircularProgressIndicator() // Affiche l'indicateur de chargement pendant le chargement
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredHotels.length,
                  itemBuilder: (context, index) {
                    final hotel =
                        filteredHotels[index].data() as Map<String, dynamic>;
                    final name = hotel['name'] as String;
                    final destination = hotel['destination'] as String;
                    final imageURL = hotel['imageURL'] as String?;
                    final phone = hotel['phone'] as String;
                    final price = hotel['price'] as String;
                    final description = hotel['description'] as String;

                    return ItemCard(
                        destination: destination,
                        imageURL: imageURL as String,
                        name: name,
                        phone: phone,
                        price: price,
                        description: description);
                    /*       ListTile(
                      title: Text(name),
                      subtitle: Text(destination),
                      leading: imageURL != null
                          ? Image.network(imageURL)
                          : Placeholder(),
                      onTap: () {
                        navigateTo(
                            context,
                            DetailPage(
                                destination: destination,
                                imageURL: imageURL as String,
                                name: name,
                                phone: phone,
                                price: price,
                                description: description));
                      },
                    );
               */
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
