import 'package:flutter/material.dart';
import '../Models/jobModel.dart';

class AnalyticsProvider with ChangeNotifier {
  // {Date:{JobId:Job}}
  Map<DateTime, Map<String, Job>> _jobsCalendar = {};
  Map<DateTime, Map<String, Job>> _currentMonthJobs = {};

  late DateTime _currentMonth;
  double _earningsForMonth = 0;

  Map<DateTime, Map<String, Job>> get jobsCalendar => _jobsCalendar;
  DateTime get currentMonth => _currentMonth;
  double get earningsForMonth => _earningsForMonth;

  void setCurrentMonth(DateTime newMonth) {
    _currentMonth = MonthAndYear(newMonth);
    populateCurrentMonthJobs();
    calculateTotal();
  }

  DateTime MonthAndYear(DateTime time) {
    return DateTime(time.year, time.month);
  }

  AnalyticsProvider(Map<DateTime, Map<String, Job>> jobs, [DateTime? currentmonth]) {
    _jobsCalendar = jobs;
    setCurrentMonth(currentmonth ?? MonthAndYear(DateTime.now()));
  }
  void populateCurrentMonthJobs() {
    _currentMonthJobs.clear();
    var jobDays = _jobsCalendar.keys;
    for (var day in jobDays) {
      if (day.month == _currentMonth.month) {
        _currentMonthJobs[day] = {};
        for (var i in _jobsCalendar[day]!.values) {
          _currentMonthJobs[day]![i.id!] = i;
        }
      }
    }
  }

  void calculateTotal() {
    _earningsForMonth = 0;
    for (var key in _currentMonthJobs.keys) {
      for (var job in _currentMonthJobs[key]!.values) {
        _earningsForMonth += job.price ?? 0;
      }
    }
  }
}
