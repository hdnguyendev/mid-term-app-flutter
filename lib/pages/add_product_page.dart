import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mid_term_app/components/my_button.dart';
import 'package:mid_term_app/helper/helper_functions.dart';
import 'dart:io';

import '../services/firestore_service.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_image == null) {
      displayMessageToUser("Please select an image", context);
      return;
    };

    // loading
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final imageUrl = await _firestoreService.uploadImage(_image!);
      String name = _nameController.text;
      double? price = double.tryParse(_priceController.text);

      if (name.isNotEmpty && price != null) {
        await _firestoreService.addProduct(name, price, imageUrl);
        _nameController.clear();
        _priceController.clear();
        setState(() {
          _image = null;
        });
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        displayMessageToUser("Input invalid", context);
      }
    } catch (e) {
      log(e.toString());
      displayMessageToUser("Error saving product", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!),
              const SizedBox(height: 10),
              MyButton(
                onTap: _pickImage,
                text: 'Pick Image',
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: _saveProduct,
                text: 'Save Product',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
