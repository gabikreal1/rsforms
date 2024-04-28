import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Repositories/company_repository.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription? _firebaseSubscription;
  RsUser _user = RsUser(companyId: "0", email: "none");
  RsUser get user {
    return _user;
  }

  UserProvider() {
    // listenToFirebase();
  }

  void listenToFirebase() async {
    _firebaseSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      _user = RsUser.fromdocument(event);
      notifyListeners();
    });

    var val = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (val.exists == false) {
      _user = RsUser(companyId: "-1", email: "none");
    }

    notifyListeners();
  }

  Future<void> addCompany(Company company) async {
    CompanyRepository.createCompany(company);
    // try {
    //   DocumentReference docRef = await FirebaseFirestore.instance.collection('companies').add(company.toMap());
    //   await FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .set({"company": docRef.id});
    //   notifyListeners();
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
