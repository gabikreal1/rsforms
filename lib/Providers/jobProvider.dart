import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import '../Models/jobModel.dart';

class JobProvider with ChangeNotifier {
  final Map<DateTime, List<Job>> _jobs = {};
  StreamSubscription? _firebaseSubscription;
  DateTime _startOfMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _endOfMonth = DateTime(DateTime.now().year, DateTime.now().month + 1);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get startOfMonth => _startOfMonth;
  DateTime get endOfmonth => _endOfMonth;
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;

  Company get company => _company;
  Map<DateTime, List<Job>> get jobs => _jobs;

  late Company _company;
  JobProvider(Company company) {
    _company = company;
    _listenToFirebase();
  }

  void setStartOfMonth(DateTime newStartOfMonth) {
    _startOfMonth = newStartOfMonth;
    _endOfMonth = DateTime(newStartOfMonth.year, newStartOfMonth.month + 1);
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    _focusedDay = DateTime(day.year, day.month, day.day);
    _selectedDay = DateTime(day.year, day.month, day.day);
    notifyListeners();
  }

  void _listenToFirebase() async {
    _firebaseSubscription = FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        // .where('timestart',
        //     isGreaterThanOrEqualTo: Timestamp.fromDate(_startOfMonth))
        // .where('timefinish',
        //     isLessThanOrEqualTo: Timestamp.fromDate(_endOfMonth))
        .snapshots()
        .listen((event) {
      _jobs.clear();
      for (var document in event.docs) {
        Job job = Job.fromdocument(document);
        _jobs.putIfAbsent(DateTime(job.earlyTime.year, job.earlyTime.month, job.earlyTime.day), () => []).add(job);
      }
      notifyListeners();
    });
  }

  Future<void> addJob(Job job) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('companies').doc(_company.id).collection('jobs').add(job.toMap());

      notifyListeners();
    } catch (e) {
      //change it
      print(e);
    }
  }

  Future<void> updateJob(String JobId, String attribute, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(JobId)
        .update(<String, dynamic>{attribute: value});
  }

  void deleteJob(String JobId) async {
    FirebaseFirestore.instance.collection('companies').doc(_company.id).collection('jobs').doc(JobId).delete();
  }

  Future<void> addService(String JobId, Services service) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(JobId)
        .collection("services")
        .add(service.toMap());
    notifyListeners();
  }

  Future<List<Services>> getServices(String jobId) async {
    var resp = await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(jobId)
        .collection('services')
        .get();
    var res = List<Services>.empty(growable: true);
    for (var doc in resp.docs) {
      res.add(Services.fromdocument(doc));
    }
    return res;
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}
