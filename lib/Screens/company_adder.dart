import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Models/invoiceModel.dart';
import 'package:rsforms/Providers/userProvider.dart';

import '../Models/jobModel.dart';

class CompanyAdder extends StatefulWidget {
  const CompanyAdder({super.key});

  @override
  State<CompanyAdder> createState() => _CompanyAdderState();
}

class _CompanyAdderState extends State<CompanyAdder> {
  int curstep = 0;
  int maxStep = 0;

  TextEditingController _companyName = new TextEditingController();
  TextEditingController _companyAddress = new TextEditingController();
  TextEditingController _companyTown = new TextEditingController();
  TextEditingController _companyPostcode = new TextEditingController();
  TextEditingController _companyPhone = new TextEditingController();
  TextEditingController _companyBankName = new TextEditingController();
  TextEditingController _companyAccountNumber = new TextEditingController();
  TextEditingController _companySortCode = new TextEditingController();
  TextEditingController _companyInvoiceCounter = new TextEditingController();
  StepState checkStepState(index) {
    if (index == curstep) {
      return StepState.editing;
    } else if (index > curstep) {
      return StepState.indexed;
    }
    return StepState.complete;
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => <Step>[
          Step(
              title: Text("Company Name"),
              content: Center(
                child: Column(
                  children: [
                    Text("It will be displayed on the Invoice"),
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintText: "Company Name",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _companyName,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              isActive: curstep >= 0,
              state: checkStepState(0)),
          Step(
              title: Text("Company Address"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Company Address",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _companyAddress,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 1,
              state: checkStepState(1)),
          Step(
              title: Text("Company City/Town"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "City/Town",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _companyTown,
                  keyboardType: TextInputType.streetAddress,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 2,
              state: checkStepState(2)),
          Step(
              title: Text("Company Postcode"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Postcode",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _companyPostcode,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 3,
              state: checkStepState(3)),
          Step(
              title: Text("Company Main Phone Number"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _companyPhone,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 4,
              state: checkStepState(4)),
          Step(
              title: Text("Comapny Main Bank Name"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Bank name (e.g. Barclays)",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _companyBankName,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 5,
              state: checkStepState(5)),
          Step(
              title: Text("Comapny Bank Account Number"),
              content: Center(
                child: Column(
                  children: [
                    Text("Account Number"),
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintText: "Contact Number",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _companyAccountNumber,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              isActive: curstep >= 6,
              state: checkStepState(6)),
          Step(
              title: Text("Company Bank Sort Code"),
              content: Center(
                child: Column(
                  children: [
                    Text("Sort Code"),
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintText: "Sort Code",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _companySortCode,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              isActive: curstep >= 7,
              state: checkStepState(7)),
          Step(
              title: Text("Initial Invoice Counter"),
              content: Center(
                child: Column(
                  children: [
                    Text("Invoice Counter"),
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintText: "by default 0",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _companyInvoiceCounter,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              isActive: curstep >= 8,
              state: checkStepState(8)),
        ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Add  Your Company",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Stepper(
                  type: StepperType.vertical,
                  physics: ClampingScrollPhysics(),
                  steps: getSteps(),
                  currentStep: curstep,
                  onStepTapped: (value) {
                    if (value <= maxStep) {
                      setState(() {
                        curstep = value;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (curstep > 0) {
                      setState(() {
                        curstep -= 1;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  onStepContinue: () {
                    if (curstep < getSteps().length - 1) {
                      setState(() {
                        if (curstep == maxStep) {
                          maxStep += 1;
                        }
                        curstep += 1;
                      });
                    } else {
                      Company company = Company(
                          InvoiceCounter: int.tryParse(_companyInvoiceCounter.text.trim()) ?? 0,
                          name: _companyName.text.trim(),
                          address: _companyAddress.text.trim(),
                          city: _companyTown.text.trim(),
                          postcode: _companyPostcode.text.trim(),
                          phoneNumber: _companyPhone.text.trim(),
                          bankName: _companyBankName.text.trim(),
                          accountNumber: _companyAccountNumber.text.trim(),
                          sortCode: _companySortCode.text.trim());
                      var provider = Provider.of<UserProvider>(context, listen: false);
                      provider.addCompany(company);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
