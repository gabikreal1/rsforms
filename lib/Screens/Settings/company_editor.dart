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
                      companyProvider.updateCompany("name", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Address",
                    TileDescription: company.address,
                    Update: (value) {
                      companyProvider.updateCompany("address", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Town",
                    TileDescription: company.city,
                    Update: (value) {
                      companyProvider.updateCompany("town", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Post Code",
                    TileDescription: company.postcode,
                    Update: (value) {
                      companyProvider.updateCompany("post_code", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Phone",
                    TileDescription: company.phoneNumber,
                    Update: (value) {
                      companyProvider.updateCompany("phone", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Bank Name",
                    TileDescription: company.bankName,
                    Update: (value) {
                      companyProvider.updateCompany("bank_name", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Account Number",
                    TileDescription: company.accountNumber,
                    Update: (value) {
                      companyProvider.updateCompany("account_number", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Sort Code",
                    TileDescription: company.sortCode,
                    Update: (value) {
                      companyProvider.updateCompany("sort_code", value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  JobEditTile(
                    TileName: "Invoice Counter",
                    TileDescription: company.InvoiceCounter.toString(),
                    Update: (value) {
                      companyProvider.updateCompany("invoice_counter", int.parse(value));
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
