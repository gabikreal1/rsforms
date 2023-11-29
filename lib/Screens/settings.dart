import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Components/my_button.dart';
import 'package:rsforms/Components/settings_button.dart';

import 'company_editor.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void navigateToCompanyEditor() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ComapanyEditor()));
  }

  void logout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Are you sure you want to logout?"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Stay"),
            ),
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Logout"),
                ],
              ),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              elevation: 20,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 115,
                width: double.infinity,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SettingsButton(
                    text: "Company Settings",
                    icon: Icons.build,
                    onTap: navigateToCompanyEditor,
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SettingsButton(
                    text: "Logout",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: logout,
                  ),
                ]),
              ),
            )
          ],
        ),
      )),
    );
  }
}
