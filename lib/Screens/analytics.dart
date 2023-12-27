// ignore_for_file: unnecessary_string_interpolations

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/JobList.dart';
import 'package:rsforms/Providers/analyticsProvider.dart';
import 'package:rsforms/Providers/jobProvider.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  String getMonth(int month) {
    Map<int, String> months = {
      1: "January",
      2: "February",
      3: "March",
      4: "April",
      5: "May",
      6: "Jun",
      7: "July",
      8: "August",
      9: "September",
      10: "October",
      11: "November",
      12: "December",
    };
    if (months.containsKey(month)) {
      return months[month]!;
    }
    return "Invalid Month";
  }

  String formatProviderName(String providerName) {
    if (providerName.length > 21) {
      return "${providerName.substring(0, 18)}...";
    }
    return providerName;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<JobProvider, AnalyticsProvider>(
      create: (BuildContext context) {
        return AnalyticsProvider(Provider.of<JobProvider>(context, listen: false).jobsCalendar);
      },
      update: (context, value, previous) {
        return AnalyticsProvider(value.jobsCalendar, previous?.currentMonth);
      },
      child: Scaffold(
        backgroundColor: const Color(0xff31384d),
        body: SafeArea(
          child: Consumer<AnalyticsProvider>(
            builder: (context, value, child) {
              List<CompanyAnalytics> companies = value.subCompanyToJobMap.values.toList();
              companies.sort(
                (b, a) => a.totalEarnings.compareTo(b.totalEarnings),
              );
              int count = min(5, companies.length);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          var curmonth = value.currentMonth;
                          curmonth = DateTime(curmonth.year, curmonth.month - 1);
                          value.setCurrentMonth(curmonth);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      Text(
                        "${value.currentMonth.year} ${getMonth(value.currentMonth.month)}",
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          var curmonth = value.currentMonth;
                          curmonth = DateTime(curmonth.year, curmonth.month + 1);
                          value.setCurrentMonth(curmonth);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
                      child: Material(
                        elevation: 20,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(children: [
                                  const Icon(Icons.account_balance_sharp),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${getMonth(value.currentMonth.month)} Revenue ",
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  "£ ${value.earningsForMonth.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                        color: const Color(0xff31384d),
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
                                                    style: const TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '£${companyAnalytics.totalEarnings.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${companyAnalytics.jobs.length} Jobs total this month',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            JobList(joblist: companyAnalytics.jobs, scrollable: true, showPrice: true)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
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
