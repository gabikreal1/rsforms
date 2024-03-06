import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Models/jobModel.dart';

class CompanyAnalytics {
  String _companyName = "";
  double _totalEarnings = 0;
  List<Job> _jobs = [];

  double get totalEarnings => _totalEarnings;
  List<Job> get jobs => _jobs;
  String get companyName => _companyName;

  CompanyAnalytics(this._jobs, this._companyName) {
    for (var job in _jobs) {
      _totalEarnings += job.price ?? 0;
    }
  }

  void addJob(Job job) {
    _totalEarnings += job.price ?? 0;
    _jobs.add(job);
  }

  void clear() {
    _totalEarnings = 0;
    _jobs.clear();
  }
}

class AnalyticsProvider with ChangeNotifier {
  // {Date:{JobId:Job}}
  Map<DateTime, Map<String, Job>> _jobsCalendar = {};
  Map<String, CompanyAnalytics> _subCompanyToJobMap = {};
  CompanyAnalytics _totalMonthly = CompanyAnalytics([], "");
  late DateTime _currentMonth;
  List<double> _totalDailyEarnings = [];

  int _currentDay = -1;
  double _currentDayEarnings = -1;

  Map<String, CompanyAnalytics> get subCompanyToJobMap => _subCompanyToJobMap;
  DateTime get currentMonth => _currentMonth;
  double get earningsForMonth => _totalMonthly.totalEarnings;
  List<double> get totalDailyEarnings => _totalDailyEarnings;
  int get currentDay => _currentDay;
  double get currentDayEarnings => _currentDayEarnings;
  Map<DateTime, Map<String, Job>> get jobsCalendar => _jobsCalendar;

  void setCurrentMonth(DateTime newMonth) {
    _currentMonth = MonthAndYear(newMonth);
    populateCurrentMonthJobs();
    notifyListeners();
  }

  void setCurrentDay(double day, double earnings) {
    _currentDay = day.toInt() + 1;
    _currentDayEarnings = earnings;
    notifyListeners();
  }

  int GetMonthLength(DateTime CurrentMonth) {
    return DateTime(CurrentMonth.year, CurrentMonth.month + 1).difference(CurrentMonth).inDays;
  }

  DateTime MonthAndYear(DateTime time) {
    return DateTime(time.year, time.month);
  }

  AnalyticsProvider(Map<DateTime, Map<String, Job>> jobs, [DateTime? currentmonth]) {
    _jobsCalendar = jobs;
    setCurrentMonth(currentmonth ?? MonthAndYear(DateTime.now()));
  }

  void populateCurrentMonthJobs() {
    _subCompanyToJobMap.clear();
    _totalMonthly.clear();
    _totalDailyEarnings = List.filled(GetMonthLength(_currentMonth), 0);

    var jobDays = _jobsCalendar.keys;
    for (var day in jobDays) {
      if (day.month == _currentMonth.month) {
        for (var job in _jobsCalendar[day]!.values) {
          if (job.price != 0) {
            _totalDailyEarnings[day.day - 1] += job.price!;
            _subCompanyToJobMap.putIfAbsent(job.subCompany, () => CompanyAnalytics([], job.subCompany)).addJob(job);
            _totalMonthly.addJob(job);
          }
        }
      }
    }
  }
}
