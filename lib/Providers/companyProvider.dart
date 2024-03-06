import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/jobModel.dart';

class CompanyProvider with ChangeNotifier {
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
  StreamSubscription? _firebaseSubscription;
  late RsUser _user;
  Company get company {
    return _company;
  }

  late String companyID;
  CompanyProvider(RsUser user) {
    _user = user;
    _listenToFirebase();
  }

  void _listenToFirebase() async {
    _firebaseSubscription =
        await FirebaseFirestore.instance.collection('companies').doc(_user.companyId).snapshots().listen((event) {
      _company = Company.fromDocument(event.data(), event.id);
      notifyListeners();
    });
  }

  Future<void> incrementInvoiceCounter() async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .update({"invoice_counter": FieldValue.increment(1)});
  }

  Future<void> updateCompany(String attribute, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .update(<String, dynamic>{attribute: value});
  }

  void setUser(RsUser user) {
    _company = company;
    _firebaseSubscription?.cancel();
    _listenToFirebase();
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
