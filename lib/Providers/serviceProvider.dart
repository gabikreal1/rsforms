import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import '../Models/jobModel.dart';

class ServiceProvider with ChangeNotifier {
  final List<Services> _services = [];
  double totalPrice = 0;

  List<Services> get services => _services;
  StreamSubscription? _firebaseSubscription;
  late String _jobId;
  late String _companyId;
  ServiceProvider(String jobId, String companyId) {
    _jobId = jobId;
    _companyId = companyId;
    _listenToFirebase();
  }
  void _listenToFirebase() async {
    _firebaseSubscription = FirebaseFirestore.instance
        .collection('companies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection('services')
        .snapshots()
        .listen((event) {
      _services.clear();
      Services service;
      totalPrice = 0;
      for (var doc in event.docs) {
        service = Services.fromdocument(doc);
        totalPrice += service.totalPrice;
        _services.add(service);
      }
      notifyListeners();
    });
  }

  void deleteService(String serviceId) {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection('services')
        .doc(serviceId)
        .delete();
  }

  Future<void> updateService(String ServiceId, String description, double price, int quantity, String type) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection('services')
        .doc(ServiceId)
        .update(<String, dynamic>{'description': description, 'price': price, 'quantity': quantity, 'type': type});
  }

  Future<void> addService(Services service) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection("services")
        .add(service.toMap());
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
