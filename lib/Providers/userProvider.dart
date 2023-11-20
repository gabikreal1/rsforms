import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Models/jobModel.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription? _firebaseSubscription;
  rsUser _user = rsUser(companyId: "0", firstname: "loh", lastname: "lohovich");
  bool isUser = false;
  rsUser get user {
    return _user;
  }

  UserProvider() {
    listenToFirebase();
  }

  void listenToFirebase() async {
    _firebaseSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      _user = rsUser.fromdocument(event);
      notifyListeners();
    });

    var val = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (val.exists == false) {
      _user = rsUser(companyId: "1", firstname: "loh", lastname: "lohovich");
    }

    notifyListeners();
  }

  Future<void> addCompany(Company company) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('companies').add(company.toMap());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"company": docRef.id});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
