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
    _firebaseSubscription = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      _user = rsUser.fromdocument(event);
      notifyListeners();
    });
    notifyListeners();

  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
