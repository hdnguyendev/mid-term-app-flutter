
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mid_term_app/auth/auth.dart';
import 'package:mid_term_app/auth/login_or_register.dart';
import 'package:mid_term_app/firebase_options.dart';
import 'package:mid_term_app/pages/register_page.dart';
import '/pages/login_page.dart';
import 'theme/dark_mode.dart';
import 'theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
