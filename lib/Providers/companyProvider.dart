import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Repositories/company_repository.dart';
import '../Models/jobModel.dart';

class CompanyProvider with ChangeNotifier {
  StreamSubscription? _companyRepositorySubscription;
  Company _company = Company(
      InvoiceCounter: 0,
      accountNumber: "0",
      address: "a",
      sortCode: "0",
      phoneNumber: "0",
      city: "0",
      bankName: "b",
      name: "s",
      id: "0",
      postcode: "9");
  Company get company {
    return _company;
  }

  CompanyProvider() {
    _listenToFirebase();
  }

  late String companyID;

  void _listenToFirebase() async {
    // Firebase Code
    // _firebaseSubscription =
    //     await FirebaseFirestore.instance.collection('companies').doc(_user.companyId).snapshots().listen((event) {
    //   _company = Company.fromDocument(event.data(), event.id);
    //   notifyListeners();
    // });
    _companyRepositorySubscription = CompanyRepository.companyStream.handleError((error) {
      if (error == "none") {
        _company = Company(
          id: "-1",
          InvoiceCounter: 0,
          accountNumber: "0",
          address: "a",
          sortCode: "0",
          phoneNumber: "0",
          city: "0",
          bankName: "b",
          name: "s",
          postcode: "9",
        );
      }
      notifyListeners();
      return;
    }).listen((event) {
      print(event);
      if (event == null) {
        _company = Company(
          id: "-1",
          InvoiceCounter: 0,
          accountNumber: "0",
          address: "a",
          sortCode: "0",
          phoneNumber: "0",
          city: "0",
          bankName: "b",
          name: "s",
          postcode: "9",
        );
      } else {
        _company = event;
      }
      notifyListeners();
    });
    await CompanyRepository.listenToCompanyUpdates();
  }

  Future<void> incrementInvoiceCounter() async {
    // await FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_company.id)
    //     .update({"invoice_counter": FieldValue.increment(1)});
    CompanyRepository.incrementCompanyInvoiceCounter();
  }

  Future<void> updateCompany(Company company) async {
    // await FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_company.id)
    //     .update(<String, dynamic>{attribute: value});

    await CompanyRepository.updateCompany(company);
  }

  Future<void> removeUser(String email) async {
    await CompanyRepository.removeUserFromCompany(email);
  }

  Future<void> promoteUserToOwner(String emailToPromote) async {
    await CompanyRepository.promoteUserToOwner(emailToPromote);
  }

  // void setUser(RsUser user) {
  //   _company = company;
  //   _firebaseSubscription?.cancel();
  //   _listenToFirebase();
  // }

  @override
  void dispose() {
    _companyRepositorySubscription?.cancel();
    // _firebaseSubscription?.cancel();
    super.dispose();
  }
}
