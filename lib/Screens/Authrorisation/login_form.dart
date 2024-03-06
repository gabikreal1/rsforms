// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Components/TextFields/auth_textfield.dart';

import '../../APIs/auth_service.dart';
import '../../Components/Buttons/main_button.dart';
import '../../Components/Dialogs/auth_error_dialog.dart';

class LoginForm extends StatefulWidget {
  final Function()? flip;
  const LoginForm({super.key, required this.flip});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _signInProgress = false;
  bool _googleSignInProgress = false;
  bool _facebookSignInProgress = false;

  @override
  Widget build(BuildContext context) {
    void signInWithEmail() async {
      if (_googleSignInProgress || _signInProgress) {
        return;
      }

      if (!_formKey.currentState!.validate()) {
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {
        _signInProgress = true;
      });

      String res = await AuthService.signUserInWithEmail(_emailController.text, _passwordController.text);

      //Handle Errors
      if (res == "success") {
        return;
      }
      showDialog(
        context: context,
        builder: (context) {
          return AuthErrorDialog(errorMessage: res);
        },
      );
      setState(() {
        _signInProgress = false;
      });
    }

    void navigateToForgotPassowrdPage() async {}

    var primaryColor = Theme.of(context).colorScheme.primary;
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    var backgroundColor = Theme.of(context).colorScheme.background;
    var tetriaryColor = Theme.of(context).colorScheme.tertiary;
    return Material(
      elevation: 20,
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Sign in",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: secondaryColor),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _emailController,
                          hintText: "Email",
                          obscureText: false,
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AuthTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          obscureText: true,
                          onSubm: signInWithEmail,
                          prefixIcon: Icons.lock_outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(right: 15),
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: RichText(
                  //       text: TextSpan(
                  //           text: "Forgot Password ?",
                  //           style: TextStyle(color: primaryColor),
                  //           recognizer: TapGestureRecognizer()..onTap = () => navigateToForgotPassowrdPage()),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  MainButton(
                    onTap: signInWithEmail,
                    text: "SIGN IN",
                    padding: 17,
                    inProgress: _signInProgress,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IntegratedAuthButton(
                    onTap: () async {
                      if (_signInProgress) {
                        return;
                      }
                      setState(() {
                        _googleSignInProgress = true;
                      });
                      var res = await AuthService.signInWithGoogle();
                      if (res != "success") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AuthErrorDialog(errorMessage: res);
                          },
                        );
                        setState(() {
                          _googleSignInProgress = false;
                        });
                      }
                    },
                    text: "CONTINUE WITH GOOGLE",
                    iconRoute: "assets/google.png",
                    color: Colors.white,
                    textColor: Colors.black,
                    inProgress: _googleSignInProgress,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have Account?"),
                      TextButton(
                        onPressed: widget.flip,
                        child: const Text("Sign up"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}