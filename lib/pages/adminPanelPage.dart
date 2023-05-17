import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/Function/function.dart';
import 'package:travel_app/pages/HotelsPublishPage.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () {
                navigateTo(context, const AdminPanelPage());
              },
            ),
            ListTile(
              title: const Text('Publier'),
              onTap: () {
                navigateTo(context, const HotelPublishPage());
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('hotels').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<QueryDocumentSnapshot> hotelDocs = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: hotelDocs.length,
                  itemBuilder: (context, index) {
                    final hotel =
                        hotelDocs[index].data() as Map<String, dynamic>;
                    final name = hotel["name"] as String;
                    final phone = hotel["phone"] as String;
                    final description = hotel["description"] as String;
                    final price = hotel["price"] as String;
                    final imageURL = hotel["imageURL"] as String;

                    return ListTile(
                      title: Text(name),
                      leading: Container(
                        width: 90.0,
                        child: imageURL != null
                            ? Image.network(imageURL)
                            : Placeholder(),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone: $phone"),
                          Text("Description: $description"),
                          Text("Price: $price"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Supprimer l'hôtel à l'aide de la référence de document
                          _firestore
                              .collection('hotels')
                              .doc(hotelDocs[index].id)
                              .delete();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
