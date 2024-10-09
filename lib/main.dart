import 'package:flutter/material.dart';
import '/pages/login_page.dart';
import 'theme/dark_mode.dart';
import 'theme/light_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
