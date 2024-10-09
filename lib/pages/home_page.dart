import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  void logout()  async{

    await FirebaseAuth.instance.signOut();

  }

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
