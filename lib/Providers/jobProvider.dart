// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/jobModel.dart';

class JobProvider with ChangeNotifier {
  StreamSubscription? _firebaseSubscription;

  //  Different maps of jobs for special UI uses
  Map<DateTime, Map<String, Job>> _jobs = {};
  Map<DateTime, Map<String, Job>> _uncompletedJobs = {};

  DateTime? _cacheTime ;
  DateTime _startOfMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _endOfMonth = DateTime(DateTime.now().year, DateTime.now().month + 1);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // getter methods
  DateTime get startOfMonth => _startOfMonth;
  DateTime get endOfmonth => _endOfMonth;
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  Company get company => _company;
  Map<DateTime, Map<String, Job>> get jobs => _jobs;
  Map<DateTime, Map<String, Job>> get uncompletedJobs => _uncompletedJobs;

  late Company _company;
  JobProvider(Company company) {
    _company = company;
    _listenToFirebase();
  }

  void setCompany(Company company) {
    _company = company;
    _firebaseSubscription?.cancel();
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

  //fetches the jobs from the firebase and fills the maps
  void _listenToFirebase() async {
    // Fetch the data from the cache and set last updated
    _cacheTime = null;
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .get(GetOptions(source: Source.cache))
        .then((value) {
      if (value.docs.isNotEmpty) {
        _cacheTime = value.docs.last.data()["lastupdated"];
        jobs.clear();
        DateTime maxTime = DateTime(2020);
        for (var document in value.docs) {
          Job job = Job.fromdocument(document);
          DateTime key = DateTime(job.earlyTime.year, job.earlyTime.month, job.earlyTime.day);

          if (job.lastUpdated != null){
            if(maxTime.compareTo(job.lastUpdated!) < 0){
              maxTime = job.lastUpdated!;
            }
          }
          if (job.removed == false) {
            _jobs.putIfAbsent(key, () => {})[job.id!] = job;
            if (job.completed == false) {
              _uncompletedJobs.putIfAbsent(key, () => {})[job.id!] = job;
            }
          }
        }
        if(maxTime.compareTo(DateTime(2020)) > 0 ){
          _cacheTime = maxTime;
        } 
    notifyListeners();

      }
      
    });

    //fetch updated events and modify the _jobs map.
    _firebaseSubscription = FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .where('lastupdated', isGreaterThanOrEqualTo: _cacheTime)
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        Job job = Job.fromdocument(document);
        DateTime key = DateTime(job.earlyTime.year, job.earlyTime.month, job.earlyTime.day);

        if (_jobs[key] != null && _jobs[key]!.containsKey(job.id)) {
          _jobs[key]!.remove(document.id);
          if (_uncompletedJobs[key] != null && _uncompletedJobs[key]!.containsKey(job.id)) {
            _uncompletedJobs[key]!.remove(document.id);
            if (_uncompletedJobs[key]!.length == 0) {
              _uncompletedJobs.remove(key);
            }
          }
          
        }
        if ((document.data()["removed"] == null || document.data()["removed"] != true)) {
          _jobs.putIfAbsent(key, () => {})[job.id!] = job;
          if (job.completed == false) {
            _uncompletedJobs.putIfAbsent(key, () => {})[job.id!] = job;
          }
        }
      }
      notifyListeners();
    });
  }

  Future<void> addJob(Job job) async {
    try {
      job.lastUpdated = DateTime.now();
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('companies').doc(_company.id).collection('jobs').add(job.toMap());

      notifyListeners();
    } catch (e) {
      //change it
      print(e);
    }
  }

  Future<void> updateJobParameter(String JobId, String attribute, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(JobId)
        .update(<String, dynamic>{attribute: value, "lastupdated": DateTime.now()});
  }

  Future<void> updateJob(Job job) async {
    job.lastUpdated = DateTime.now();
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(job.id)
        .update(job.toMap());
  }

  void deleteJob(String JobId) async {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(_company.id)
        .collection('jobs')
        .doc(JobId)
        .update(<String, dynamic>{"removed": true, "lastupdated": DateTime.now()});
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
