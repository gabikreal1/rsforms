import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/JobList.dart';
import '../Providers/jobProvider.dart';

class UncompletedJobs extends StatefulWidget {
  const UncompletedJobs({super.key});

  @override
  State<UncompletedJobs> createState() => _UncompletedJobsState();
}

class _UncompletedJobsState extends State<UncompletedJobs> {
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

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final today = DateTime.now();
    return Scaffold(
      backgroundColor: const Color(0xff31384d),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color(0xff31384d),
          ),
          height: double.infinity,
          width: double.infinity,
          child: Consumer<JobProvider>(builder: (context, jobprovider, child) {
            // days
            var days = jobProvider.uncompletedJobs.keys.toList();

            if (days.isEmpty) {
              return Center(
                child: const Text(
                  "There are no any awaiting jobs",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }
            days.sort((a, b) => a.compareTo(b));
            return ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  var day = days[index];
                  var joblist = jobProvider.uncompletedJobs[day]!.values.toList();
                  joblist.sort((a, b) => a.startTime.compareTo(b.startTime));
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                DateTime(day.year, day.month, day.day) != DateTime(today.year, today.month, today.day)
                                    ? Text(
                                        "${getMonth(day.month)} ${day.day}/${day.year}",
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        "Today",
                                        style: TextStyle(color: Colors.white),
                                      ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      JobList(
                        context: context,
                        joblist: joblist,
                        scrollable: false,
                      ),
                    ],
                  );
                });
          }),
        ),
      ),
    );
  }
}
