import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/JobList.dart';
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
    String formatProviderName(String providerName) {
      if (providerName.length > 18) {
        return "${providerName.substring(0, 15)}...";
      }
      return providerName;
    }

    return ChangeNotifierProxyProvider<JobProvider, AnalyticsProvider>(
      create: (BuildContext context) {
        return AnalyticsProvider(Provider.of<JobProvider>(context, listen: false).jobsCalendar);
      },
      update: (context, value, previous) {
        return AnalyticsProvider(value.jobsCalendar, previous?.currentMonth);
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<AnalyticsProvider>(
            builder: (context, value, child) {
              // return Text(
              //   "December earnings till today: £${value.earningsForMonth.toStringAsFixed(2)}",
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // );
              List<CompanyAnalytics> companies = value.subCompanyToJobMap.values.toList();
              companies.sort(
                (b, a) => a.totalEarnings.compareTo(b.totalEarnings),
              );
              int count = min(5, companies.length);
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Total earnings this month: £${value.earningsForMonth.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: count,
                      itemBuilder: ((context, index) {
                        CompanyAnalytics companyAnalytics = companies[index];

                        companyAnalytics.jobs.sort(
                          (a, b) => a.earlyTime.compareTo(b.earlyTime),
                        );
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xff31384d),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
                              child: ExpansionTile(
                                backgroundColor: Colors.transparent,
                                shape: const Border(),
                                controlAffinity: ListTileControlAffinity.leading,
                                collapsedIconColor: Colors.white,
                                title: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${formatProviderName(companyAnalytics.companyName)}',
                                          style:
                                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Spacer(),
                                        Text(
                                          '£${companyAnalytics.totalEarnings.toStringAsFixed(2)}',
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${companyAnalytics.jobs.length} Jobs total this month',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [JobList(joblist: companyAnalytics.jobs, scrollable: true, showPrice: true)],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
