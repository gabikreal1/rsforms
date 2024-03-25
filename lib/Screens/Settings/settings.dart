import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Components/Buttons/settings_button.dart';

import 'company_editor.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
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
    );
  }
}

class _SettingsState extends State<Settings> {
  void navigateToCompanyEditor() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ComapanyEditor()));
  }

  void navigateToCompanyMembers() async {}

  void navigateToJobTemplate() async {}

  void navigateToContractors() async {}

  void navigateToFrequentClients() async {}

  void exitCompany() async {}
  void logout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("Are you sure you want to logout?"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Stay"),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              child: const Row(
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff31384d),
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
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 115,
                width: double.infinity,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SettingsButton(
                    text: "Company Invoice Details",
                    icon: Icons.document_scanner,
                    onTap: navigateToCompanyEditor,
                  ),
                  const SettingsDivider(),
                  SettingsButton(
                    text: "Company Job Template",
                    icon: Icons.build,
                    onTap: navigateToJobTemplate,
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              elevation: 20,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 180,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsButton(
                      text: "Company Members",
                      icon: Icons.business_rounded,
                      onTap: navigateToCompanyMembers,
                    ),
                    const SettingsDivider(),
                    SettingsButton(
                      text: "Company Contractors",
                      icon: Icons.work,
                      onTap: navigateToContractors,
                    ),
                    const SettingsDivider(),
                    SettingsButton(
                      text: "Company Frequent Clients",
                      icon: Icons.people,
                      onTap: navigateToFrequentClients,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 20,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 115,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsButton(
                      text: "Leave Company",
                      icon: Icons.exit_to_app,
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: exitCompany,
                    ),
                    const SettingsDivider(),
                    SettingsButton(
                      text: "Logout",
                      icon: Icons.logout,
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
