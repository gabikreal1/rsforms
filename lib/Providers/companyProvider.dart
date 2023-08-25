import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Company get company {
    return _company;
  }

  CompanyProvider() {
    _listenToFirebase();
  }

  void _listenToFirebase() async {
    _firebaseSubscription = await FirebaseFirestore.instance
        .collection('companies')
        .doc('p7NxaqeggifpoF0R9aGS')
        .snapshots()
        .listen((event) {
      _company = Company.fromDocument(event.data(), event.id);
      notifyListeners();
    });
  }

  Future<void> incrementInvoiceCounter() async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc('p7NxaqeggifpoF0R9aGS')
        .update({"invoice_counter": FieldValue.increment(1)});
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
