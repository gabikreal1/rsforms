// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rsforms/Repositories/company_repository.dart';
import 'package:rsforms/Repositories/jobs_repository.dart';
import '../Models/jobModel.dart';

class JobProvider with ChangeNotifier {
  StreamSubscription? _jobSubscription;

  // Different maps of jobs for special UI uses
  //Key,Value {Day : {Id:Job}}
  final Map<DateTime, Map<String, Job>> _jobsCalendar = {};
  final Map<DateTime, Map<String, Job>> _uncompletedJobs = {};
  //detect duplicates in job update.
  final Map<String, Job> _jobs = {};

  DateTime? _cacheTime;
  DateTime _startOfMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _endOfMonth = DateTime(DateTime.now().year, DateTime.now().month + 1);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // getter methods
  DateTime get startOfMonth => _startOfMonth;
  DateTime get endOfmonth => _endOfMonth;
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  Map<DateTime, Map<String, Job>> get jobsCalendar => _jobsCalendar;
  Map<DateTime, Map<String, Job>> get uncompletedJobs => _uncompletedJobs;

  late Company _company;
  JobProvider() {
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

  Future<void> loadCache() async {
    // await FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_company.id)
    //     .collection('jobs')
    //     .get(GetOptions(source: Source.cache))
    //     .then((value) {
    //   if (value.docs.isNotEmpty) {
    //     if (value.docs.last.data()["lastupdated"].runtimeType == Timestamp) {
    //       _cacheTime = (value.docs.last.data()["lastupdated"] as Timestamp).toDate();
    //     } else {
    //       _cacheTime = value.docs.last.data()["lastupdated"];
    //     }
    //     _jobsCalendar.clear();
    //     _jobs.clear();
    //     DateTime maxTime = DateTime(2020);
    //     for (var document in value.docs) {
    //       Job job = Job.fromdocument(document);
    //       _jobs[job.id!] = job;
    //       DateTime key = DateTime(job.startTime.year, job.startTime.month, job.startTime.day);

    //       if (job.lastUpdated != null) {
    //         if (maxTime.compareTo(job.lastUpdated!) < 0) {
    //           maxTime = job.lastUpdated!;
    //         }
    //       }
    //       if (job.removed == false) {
    //         _jobsCalendar.putIfAbsent(key, () => {})[job.id!] = job;
    //         if (job.completed == false) {
    //           _uncompletedJobs.putIfAbsent(key, () => {})[job.id!] = job;
    //         }
    //       }
    //     }
    //     if (maxTime.compareTo(DateTime(2020)) > 0) {
    //       _cacheTime = maxTime;
    //     }
    //   }
    // });
  }

  //fetches the jobs from the firebase and fills the maps
  void _listenToFirebase() async {
    // Fetch the data from the cache and set last updated
    _cacheTime = null;
    await loadCache();
    await JobRepository.listenToJobUpdates();

    //fetch updated events and modify the _jobs map.
    _jobSubscription = JobRepository.jobStream.listen((event) {
      if (event == null) {
        return;
      }
      for (var job in event) {
        if (job == null) {
          continue;
        }
        if (_jobs.containsKey(job.id)) {
          //remove prev duplicate from the calendar map
          Job prevJob = _jobs[job.id]!;
          DateTime prevKey = DateTime(prevJob.startTime.year, prevJob.startTime.month, prevJob.startTime.day);
          _jobsCalendar[prevKey]?.remove(prevJob.id);
          if (_jobsCalendar[prevKey] != null && _jobsCalendar[prevKey]!.values.isEmpty) {
            _jobsCalendar.remove(prevKey);
          }

          if (prevJob.completed == false) {
            _uncompletedJobs[prevKey]?.remove(prevJob.id);
            if (_uncompletedJobs[prevKey] != null && _uncompletedJobs[prevKey]!.values.isEmpty) {
              _uncompletedJobs.remove(prevKey);
            }
          }
        }
        _jobs[job.id!] = job;

        DateTime key = DateTime(job.startTime.year, job.startTime.month, job.startTime.day);

        if (job.removed == null || job.removed != true) {
          _jobsCalendar.putIfAbsent(key, () => {})[job.id!] = job;
          if (job.completed == false) {
            _uncompletedJobs.putIfAbsent(key, () => {})[job.id!] = job;
          }
        }
      }
      notifyListeners();
    });

    if (_cacheTime == null) {
      await JobRepository.getAllJobs();
    } else {
      await JobRepository.getLastUpdatedJobs(_cacheTime?.millisecondsSinceEpoch ?? 0);
    }

    notifyListeners();
  }

  Future<void> addJob(Job job) async {
    JobRepository.createJob(job);
    // try {
    //   job.lastUpdated = DateTime.now();
    //   DocumentReference docRef =
    //       await FirebaseFirestore.instance.collection('companies').doc(_company.id).collection('jobs').add(job.toMap());

    //   notifyListeners();
    // } catch (e) {
    //   //change it
    //   print(e);
    // }
  }

  // Future<void> updateJobParameter(String JobId, String attribute, dynamic value) async {
  //   await FirebaseFirestore.instance
  //       .collection('companies')
  //       .doc(_company.id)
  //       .collection('jobs')
  //       .doc(JobId)
  //       .update(<String, dynamic>{attribute: value, "lastupdated": DateTime.now()});
  // }

  Future<void> updateJob(Job job) async {
    job.lastUpdated = DateTime.now();
    JobRepository.updateJob(job);
    // await FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_company.id)
    //     .collection('jobs')
    //     .doc(job.id)
    //     .update(job.toMap());
  }

  void deleteJob(Job job) async {
    JobRepository.removeJob(job);
    // FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(_company.id)
    //     .collection('jobs')
    //     .doc(JobId)
    //     .update(<String, dynamic>{"removed": true, "lastupdated": DateTime.now()});
  }

  @override
  void dispose() {
    _jobSubscription?.cancel();
    super.dispose();
  }
}
