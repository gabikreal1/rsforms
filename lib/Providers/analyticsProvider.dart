import 'dart:ffi';
import 'dart:math';

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
  List<double> _cumulativeDailyEarnings = [];

  int _currentDay = -1;
  double _currentDayEarnings = -1;

  Map<String, CompanyAnalytics> get subCompanyToJobMap => _subCompanyToJobMap;
  DateTime get currentMonth => _currentMonth;
  double get earningsForMonth => _totalMonthly.totalEarnings;
  List<double> get totalDailyEarnings => _totalDailyEarnings;
  int get currentDay => _currentDay;
  double get currentDayEarnings => _currentDayEarnings;
  Map<DateTime, Map<String, Job>> get jobsCalendar => _jobsCalendar;
  List<double> get cumulativeDailyEarnings => _cumulativeDailyEarnings;

  void setCurrentMonth(DateTime newMonth) {
    _currentMonth = monthAndYear(newMonth);
    _currentDay = -1;
    _currentDayEarnings = -1;
    populateCurrentMonthJobs();
    notifyListeners();
  }

  void setCurrentDay(int day) {
    _currentDay = day.toInt();
    _currentDayEarnings = _totalDailyEarnings[day.toInt() - 1];
    notifyListeners();
  }

  int getMonthLength(DateTime CurrentMonth) {
    // Edge case for febuary in leap years
    if (CurrentMonth.year % 4 == 0 && CurrentMonth.month == 2) {
      return 29;
    }
    //map of month - monthLenght
    Map<int, int> monthToMonthLength = {
      1: 31,
      2: 28,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31,
    };

    return monthToMonthLength[CurrentMonth.month] ?? 0;
  }

  DateTime monthAndYear(DateTime time) {
    return DateTime(time.year, time.month);
  }

  AnalyticsProvider(Map<DateTime, Map<String, Job>> jobs, [DateTime? currentmonth]) {
    _jobsCalendar = jobs;
    setCurrentMonth(currentmonth ?? monthAndYear(DateTime.now()));
  }

  void populateCurrentMonthJobs() {
    _subCompanyToJobMap.clear();
    _totalMonthly.clear();

    if (_currentMonth.month == DateTime.now().month && _currentMonth.year == DateTime.now().year) {
      _totalDailyEarnings = List.filled(DateTime.now().day, 0);
      _cumulativeDailyEarnings = List.filled(DateTime.now().day, 0);
    } else {
      _totalDailyEarnings = List.filled(getMonthLength(_currentMonth), 0);
      _cumulativeDailyEarnings = List.filled(getMonthLength(_currentMonth), 0);
    }

    var jobDays = _jobsCalendar.keys;
    for (var day in jobDays) {
      if (day.month == _currentMonth.month && day.year == _currentMonth.year) {
        for (var job in _jobsCalendar[day]!.values) {
          //checks if the job price is more than 0 and checks if the price is assigned on the day or after.
          if (job.price != 0 && day.day <= _totalDailyEarnings.length) {
            _totalDailyEarnings[day.day - 1] += job.price!;
            _subCompanyToJobMap.putIfAbsent(job.subCompany, () => CompanyAnalytics([], job.subCompany)).addJob(job);
            _totalMonthly.addJob(job);
          }
        }
      }
    }
    _cumulativeDailyEarnings[0] = _totalDailyEarnings[0];
    for (int day = 1; day < _totalDailyEarnings.length; day++) {
      _cumulativeDailyEarnings[day] = _cumulativeDailyEarnings[day - 1] + _totalDailyEarnings[day];
    }
  }
}
