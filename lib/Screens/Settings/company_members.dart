import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/companyMembersList.dart';
import 'package:rsforms/Providers/companyProvider.dart';

class CompanyMembersPage extends StatefulWidget {
  const CompanyMembersPage({super.key});

  @override
  State<CompanyMembersPage> createState() => _CompanyMembersPageState();
}

class _CompanyMembersPageState extends State<CompanyMembersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<CompanyProvider>(
            builder: (context, value, child) {
              var company = value.company;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          )),
                      const Text(
                        "Company Members",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 1000,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CompanyMemberList(
                          users: company.users!,
                          remove: ((email) async {
                            await value.removeUser(email);
                          }),
                          owneruserId: company.ownerUserId ?? "-1",
                          shareCode: company.shareCode ?? "None"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
