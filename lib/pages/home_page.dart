import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mid_term_app/pages/detail_product_page.dart';
import 'package:mid_term_app/services/firestore_service.dart';

import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Products'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder(
          stream: firestoreService.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List products = snapshot.data!.docs;

              if (products.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("No products found", style: TextStyle(fontSize: 20)),
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Image(image: AssetImage('lib/images/not-found-image.png'), width: 200, height: 200),
                          )
                        ],
                      ),
                    ),
                  ),

                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = products[index];
                    String productId = doc.id;

                    // get each individual doc
                    Map<String, dynamic> product =
                        doc.data() as Map<String, dynamic>;
                    product['id'] = productId;
                    String name = product['name'];
                    double price = product['price'];
                    String imageUrl = product['imageUrl'];

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(price.toString()),
                      leading: Image.network(imageUrl),
                      onTap: () {
                        // open detail page using
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailProductPage(product: product)));
                      },
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => AddProductPage());
          Navigator.push(context, route);

          // showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //           content: TextField(
          //             controller: textController,
          //             decoration: const InputDecoration(hintText: "Enter note"),
          //           ),
          //           actions: [
          //             TextButton(
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: const Text("Cancel")),
          //             TextButton(
          //                 onPressed: () {
          //                   // Add note to database
          //                   firestoreService.addNote(textController.text);
          //                   textController.clear();
          //
          //                   Navigator.pop(context);
          //                 },
          //                 child: const Text("Save")),
          //           ],
          //         ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
