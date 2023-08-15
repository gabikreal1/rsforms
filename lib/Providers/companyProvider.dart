import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/jobModel.dart';

class CompanyProvider with ChangeNotifier {
  late Company _company;
  Company get company {
    return _company;
  }

  CompanyProvider() {
    _listenToFirebase();
  }

  void _listenToFirebase() async {
    _company = Company.fromDocument(
        await FirebaseFirestore.instance.collection('companies').doc('p7NxaqeggifpoF0R9aGS').get());
  }

  void incrementInvoiceCounter() async {
    FirebaseFirestore.instance
        .collection('companies')
        .doc('p7NxaqeggifpoF0R9aGS')
        .update({"invoice_counter": FieldValue.increment(1)});
  }
}
