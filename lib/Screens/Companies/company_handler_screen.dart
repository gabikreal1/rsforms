import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Screens/Companies/company_adder.dart';
import 'package:rsforms/Screens/Companies/company_joiner.dart';

import '../../Services/auth_service.dart';

class CompanyHandlerScreen extends StatelessWidget {
  const CompanyHandlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: CompanyNavigationButtonTile(
              iconData: Icons.add,
              label: "Create New Company",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CompanyAdder()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 2,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: CompanyNavigationButtonTile(
              iconData: Icons.exit_to_app,
              label: "Join Existing Company",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyJoiner()),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class CompanyNavigationButtonTile extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function() callback;

  const CompanyNavigationButtonTile({super.key, required this.iconData, required this.label, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        splashFactory: NoSplash.splashFactory,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
      onPressed: () => callback(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 90),
          child: Column(
            children: [
              Icon(
                iconData,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
