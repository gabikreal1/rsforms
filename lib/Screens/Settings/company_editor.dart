import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/JobEditTile.dart';
import 'package:rsforms/Providers/companyProvider.dart';

class ComapanyEditor extends StatefulWidget {
  ComapanyEditor({super.key});

  @override
  State<ComapanyEditor> createState() => _ComapanyEditorState();
}

class _ComapanyEditorState extends State<ComapanyEditor> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var companyProvider = Provider.of<CompanyProvider>(context, listen: false);

    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<CompanyProvider>(
            builder: (context, value, child) {
              var company = value.company;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Name",
                    TileDescription: company.name,
                    Update: (value) {
                      company.name = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Address",
                    TileDescription: company.address,
                    Update: (value) {
                      company.address = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "City",
                    TileDescription: company.city,
                    Update: (value) {
                      company.city = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Post Code",
                    TileDescription: company.postcode,
                    Update: (value) {
                      company.postcode = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Phone",
                    TileDescription: company.phoneNumber,
                    Update: (value) {
                      company.phoneNumber = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Bank Name",
                    TileDescription: company.bankName,
                    Update: (value) {
                      company.bankName = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Account Number",
                    TileDescription: company.accountNumber,
                    Update: (value) {
                      company.accountNumber = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Sort Code",
                    TileDescription: company.sortCode,
                    Update: (value) {
                      company.sortCode = value;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Invoice Counter",
                    TileDescription: company.InvoiceCounter.toString(),
                    Update: (value) {
                      company.InvoiceCounter = int.tryParse(value) ?? company.InvoiceCounter;
                      companyProvider.updateCompany(company);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}
