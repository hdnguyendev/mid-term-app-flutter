import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mid_term_app/components/my_button.dart';
import 'package:mid_term_app/services/firestore_service.dart';

class DetailProductPage extends StatefulWidget {
  final Map product;

  const DetailProductPage({super.key, required this.product});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final FirestoreService firestoreService = FirestoreService();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    productNameController.text = widget.product['name'];
    productPriceController.text = widget.product['price'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Product'),
        actions: [
          IconButton(
            onPressed: () {
              // confirm delete
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Product'),
                  content: const Text('Are you sure you want to delete this product?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.green)),
                    ),
                    TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        await firestoreService.deleteProduct(widget.product['id']);

                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              });
            },
            icon: Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: productPriceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // pick image
                  _pickImage();
                },
                child: _image != null
                    ? Image.file(
                        _image!) // Hiển thị ảnh mới nếu người dùng chọn
                    : Image.network(
                        widget.product['imageUrl']), // Hiển thị ảnh cũ
              ),
              const SizedBox(height: 10),
              MyButton(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  // Kiểm tra nếu có ảnh mới, nếu không, giữ nguyên ảnh cũ
                  String imageUrl = widget.product['imageUrl'];
                  if (_image != null) {
                    // Nếu có ảnh mới, thực hiện upload lên Firestore (nếu cần) và nhận URL mới
                    imageUrl = await firestoreService.uploadImage(_image!);
                  }

                  // Cập nhật sản phẩm với tên, giá và URL ảnh
                  firestoreService.updateProductWithImage(
                    widget.product['id'],
                    productNameController.text,
                    double.parse(productPriceController.text),
                    imageUrl, // URL của ảnh mới hoặc cũ
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: 'Update Product',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
