// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rsforms/Components/Buttons/main_button.dart';
import 'package:rsforms/Components/TextFields/default_textfield.dart';
import 'package:rsforms/Repositories/company_repository.dart';

class CompanyJoiner extends StatefulWidget {
  CompanyJoiner({super.key});

  @override
  State<CompanyJoiner> createState() => _CompanyJoinerState();
}

class _CompanyJoinerState extends State<CompanyJoiner> {
  final TextEditingController controller = TextEditingController();
  bool isEnabled = false;
  bool inProgress = false;

  void onType(
    String val,
  ) {
    if (val.isNotEmpty) {
      setState(() {
        isEnabled = true;
      });
    } else {
      setState(() {
        isEnabled = false;
      });
    }
  }

  void onJoin() async {
    setState(() {
      inProgress = true;
    });

    ///Really not beautiful to call repository from here
    await CompanyRepository.joinCompany(controller.text.trim());
    setState(() {
      inProgress = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Your Company Join Code",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            DefaultTextField(
              controller: controller,
              hintText: "Join Code",
              onChange: onType,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            MainButton(
              onTap: onJoin,
              text: "Join",
              inProgress: inProgress,
              padding: 17,
              isEnabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
