import 'package:flutter/material.dart';
import 'package:mid_term_app/components/my_button.dart';
import 'package:mid_term_app/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void login() {
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
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


                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    Text(
                      " Register here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
