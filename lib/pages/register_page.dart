import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mid_term_app/components/my_button.dart';
import 'package:mid_term_app/components/my_textfield.dart';

import '../helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordConfirmedController =
      TextEditingController();

  Future<void> registerUser() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // make sure passwords match
    if (passwordController.text != passwordConfirmedController.text) {
      // close loading circle
      Navigator.pop(context);

      displayMessageToUser("Passwords don't match", context);
    } else {
      // create user
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // close loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // close loading circle
        Navigator.pop(context);

        if (e.code == 'weak-password') {
          displayMessageToUser('The password provided is too weak.', context);
        } else if (e.code == 'email-already-in-use') {
          displayMessageToUser(
              'The account already exists for that email.', context);
        } else {
          displayMessageToUser(e.code, context);
        }
      }
    }
    // try to create user
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
                      hintText: "Username",
                      obscureText: false,
                      controller: usernameController),
                  //
                  const SizedBox(height: 10),
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
                  MyTextField(
                      hintText: "Confirm Password",
                      obscureText: true,
                      controller: passwordConfirmedController),
                  const SizedBox(height: 25),
                  //
                  MyButton(
                      text: "Register",
                      onTap: () {
                        registerUser();
                      }),
                  //
                  const SizedBox(height: 25),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          " Login here",
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
