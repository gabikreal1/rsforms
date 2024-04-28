import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Repositories/services_repository.dart';
import '../Models/jobModel.dart';

class ServiceProvider with ChangeNotifier {
  final List<Services> _services = [];
  double totalPrice = 0;

  List<Services> get services => _services;
  StreamSubscription? _serviceSubscription;
  late String _jobId;
  ServiceProvider(String jobId) {
    _jobId = jobId;
    _listenToFirebase();
  }
  void _listenToFirebase() async {
    // _firebaseSubscription = FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_companyId)
    //     .collection('jobs')
    //     .doc(_jobId)
    //     .collection('services')
    //     .snapshots()
    //   .listen((event) {
    // _services.clear();
    // Services service;
    // totalPrice = 0;
    // for (var doc in event.docs) {
    //   service = Services.fromdocument(doc);
    //   totalPrice += service.totalPrice;
    //   _services.add(service);
    // }
    // notifyListeners();
    // });
    await ServicesRepository.listenToServiceUpdates(_jobId);
    _serviceSubscription = ServicesRepository.serviceStream.listen((event) {
      _services.clear();

      totalPrice = 0;
      if (event == null) {
        return;
      }
      for (var service in event) {
        if (service == null) {
          continue;
        }
        //Слишком рукожопый чтобы сделать это в бэкэнде
        service.jobId = _jobId;
        totalPrice += service.totalPrice;
        _services.add(service);
      }
      notifyListeners();
    });
  }

  void deleteService(String serviceId) {
    ServicesRepository.removeService(serviceId);
    // FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_companyId)
    //     .collection('jobs')
    //     .doc(_jobId)
    //     .collection('services')
    //     .doc(serviceId)
    //     .delete();
  }

  Future<void> updateService(Services service) async {
    // await FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_companyId)
    //     .collection('jobs')
    //     .doc(_jobId)
    //     .collection('services')
    //     .doc(ServiceId)
    //     .update(<String, dynamic>{'description': description, 'price': price, 'quantity': quantity, 'type': type});
    ServicesRepository.updateService(service);
  }

  Future<void> addService(Services service) async {
    service.jobId = _jobId;
    ServicesRepository.createService(service);
  }

  @override
  void dispose() {
    _serviceSubscription?.cancel();
    ServicesRepository.stopListeningToUpdates();
    super.dispose();
  }
}
