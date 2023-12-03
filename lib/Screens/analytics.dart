import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Providers/analyticsProvider.dart';
import 'package:rsforms/Providers/jobProvider.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<JobProvider, AnalyticsProvider>(
      create: (BuildContext context) {
        return AnalyticsProvider(Provider.of<JobProvider>(context, listen: false).jobs);
      },
      update: (context, value, previous) {
        return AnalyticsProvider(value.jobs, previous?.currentMonth);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Consumer<AnalyticsProvider>(
              builder: (context, value, child) {
                return Text(
                  "December earnings till today: £${value.earningsForMonth.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
