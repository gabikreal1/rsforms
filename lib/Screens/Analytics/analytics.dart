// ignore_for_file: unnecessary_string_interpolations

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/JobList.dart';
import 'package:rsforms/Components/revenue_chart.dart';
import 'package:rsforms/Providers/analyticsProvider.dart';
import 'package:rsforms/Providers/jobProvider.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  int segmentedControlGroupValue = 0;

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
    var primaryColor = Theme.of(context).colorScheme.primary;
    return ChangeNotifierProxyProvider<JobProvider, AnalyticsProvider>(
      create: (BuildContext context) {
        return AnalyticsProvider(Provider.of<JobProvider>(context, listen: false).jobsCalendar);
      },
      update: (context, value, previous) {
        return AnalyticsProvider(value.jobsCalendar, previous?.currentMonth);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<AnalyticsProvider>(
            builder: (context, value, child) {
              List<CompanyAnalytics> companies = value.subCompanyToJobMap.values.toList();
              companies.sort(
                (b, a) => a.totalEarnings.compareTo(b.totalEarnings),
              );
              int count = min(5, companies.length);
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              var curmonth = value.currentMonth;
                              curmonth = DateTime(curmonth.year, curmonth.month - 1);
                              value.setCurrentMonth(curmonth);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${value.currentMonth.year} ${getMonth(value.currentMonth.month)}",
                            style: const TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              var curmonth = value.currentMonth;
                              curmonth = DateTime(curmonth.year, curmonth.month + 1);
                              value.setCurrentMonth(curmonth);
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ],
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
                              " ${getMonth(value.currentMonth.month)} Revenue ",
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
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        color: const Color(0xff31384d),
                        borderRadius: BorderRadius.circular(20),
                        elevation: 10,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            CupertinoSlidingSegmentedControl(
                                groupValue: segmentedControlGroupValue,
                                children: <int, Widget>{
                                  0: Text("Daily Graph",
                                      style: TextStyle(
                                          color: segmentedControlGroupValue == 0 ? Colors.black : Colors.white)),
                                  1: Text("Main Contractors",
                                      style: TextStyle(
                                          color: segmentedControlGroupValue == 1 ? Colors.black : Colors.white))
                                },
                                onValueChanged: (i) {
                                  setState(() {
                                    segmentedControlGroupValue = i ?? segmentedControlGroupValue;
                                  });
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            if (segmentedControlGroupValue == 0)
                              Column(
                                children: [
                                  if (value.currentDay != -1)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 45),
                                          child: Text(
                                            "${value.currentDay} ${getMonth(value.currentMonth.month)}",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Text(
                                            "+£${value.currentDayEarnings.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Colors.green[300], fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    SizedBox(
                                      height: 23,
                                    ),
                                  RevenueChart(
                                    data: value.cumulativeDailyEarnings,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                    child: Column(
                                      children: [
                                        (value.currentDay != -1)
                                            ? JobList(
                                                context: context,
                                                joblist: value
                                                        .jobsCalendar[DateTime(value.currentMonth.year,
                                                            value.currentMonth.month, value.currentDay)]
                                                        ?.values
                                                        .where((element) => element.price != null && element.price! > 0)
                                                        .toList() ??
                                                    [],
                                                scrollable: true,
                                                showPrice: true,
                                              )
                                            : Container(
                                                height: 10,
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
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
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
                                          child: ListTile(
                                            shape: const Border(),
                                            title: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${index + 1}. ${formatProviderName(companyAnalytics.companyName)}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '+£${companyAnalytics.totalEarnings.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          color: Colors.green[600],
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold),
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
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
