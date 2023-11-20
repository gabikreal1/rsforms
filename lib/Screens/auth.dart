// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rsforms/Components/my_button.dart';
import 'package:rsforms/Components/my_texfield.dart';

import '../APIs/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> signUserIn() async {
    //login
    final responseCode = await AuthService().signUserInWithEmail(usernameController.text, passwordController.text);
    if (responseCode != "success") {
      loginErrorDialogShower(responseCode, context);
    }
  }

  void loginErrorDialogShower(String responseCode, BuildContext context) {
    //wrong email
    if (responseCode == 'user-not-found') {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incorrect Email'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Retry"))],
            elevation: 24.0,
          );
        },
      );
    }

    //wrong password
    else if (responseCode == 'wrong-password') {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incorrect Password'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Retry"))],
            elevation: 24.0,
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(responseCode),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Retry"))],
            elevation: 24.0,
          );
        },
      );
    }
  }

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  onSubm: signUserIn,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: MyButton(
                    padding: 20,
                    onTap: signUserIn,
                    text: "SIGN IN",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: IntegratedButton(
                    textColor: Colors.black,
                    iconRoute: 'assets/google.png',
                    color: Colors.white,
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                                child: Container(height: 40, width: 40, child: CircularProgressIndicator.adaptive()));
                          });
                      AuthService().signInWithGoogle();
                      Navigator.pop(context);
                    },
                    text: "SIGN IN WITH GOOGLE",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
