import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  // upload image to firebase storage
  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  // add product to firestore
  Future<void> addProduct(String name, double price, String imageUrl) async {
    await products.add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  // delete product from firestore
  Future<void> deleteProduct(String productId) async {
    try {
      await products.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  // update product in firestore without image
  Future<void> updateProduct(
      String productId, String name, double price) async {
    try {
      await products.doc(productId).update({
        'name': name,
        'price': price,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  // update product in firestore with image
  Future<void> updateProductWithImage(
      String productId, String name, double price, String imageUrl) async {
    if (imageUrl.isEmpty) {
      await updateProduct(productId, name, price);
      return;
    }

    try {
      await products.doc(productId).update({
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  // get all products from firestore
  Stream<QuerySnapshot> getProducts() {
    final productsStream =
        products.orderBy('createdAt', descending: true).snapshots();
    return productsStream;
  }
}
