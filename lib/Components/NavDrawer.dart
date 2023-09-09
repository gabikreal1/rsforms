import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import 'package:rsforms/Screens/calendar.dart';
import 'package:rsforms/Screens/company_editor.dart';

// to finish the navigation logic.
class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Provider.of<CompanyProvider>(context).company.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Calendar'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Calendar()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Company'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComapanyEditor()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {FirebaseAuth.instance.signOut()},
            ),
          ],
        ),
      ),
    );
  }
}
