import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mid_term_app/components/my_button.dart';
import 'package:mid_term_app/components/my_textfield.dart';

import '../helper/helper_functions.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async{
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      // mounted có nghĩa là widget đó đã được build và nó không bị dispose hay bị hủy
      if (context.mounted) {
        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      displayMessageToUser("Wrong email or password!", context);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  //
                  const SizedBox(height: 25),
                  //
                  Text("KFitness Center",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  //
                  const SizedBox(height: 50),
                  MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: emailController),
                  //
                  const SizedBox(height: 10),
                  MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: passwordController),
                  const SizedBox(height: 10),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  const SizedBox(height: 10),
                  //
                  MyButton(
                      text: "Login",
                      onTap: () {
                        login();
                      }),
                  //
                  const SizedBox(height: 25),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          " Register here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
