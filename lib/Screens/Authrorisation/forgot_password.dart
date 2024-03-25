// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rsforms/Components/Buttons/main_button.dart';

import 'package:rsforms/Components/Dialogs/auth_error_dialog.dart';
import 'package:rsforms/Components/TextFields/auth_textfield.dart';

import '../../APIs/auth_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  void resetPasswordSubm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final responseCode = await AuthService.resetPassword(email.text);
    if (responseCode != "success") {
      AuthErrorDialog(errorMessage: responseCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Enter your email and we will send you \n a password reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AuthTextField(
                  controller: email,
                  hintText: "Email",
                  onSubm: resetPasswordSubm,
                  obscureText: false,
                  prefixIcon: Icons.mail,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: MainButton(
                  inProgress: false,
                  padding: 17,
                  onTap: resetPasswordSubm,
                  text: "Reset Password",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
