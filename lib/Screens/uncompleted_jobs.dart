import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/JobList.dart';
import '../Providers/jobProvider.dart';

class uncompletedJobs extends StatefulWidget {
  const uncompletedJobs({super.key});

  @override
  State<uncompletedJobs> createState() => _uncompletedJobsState();
}

class _uncompletedJobsState extends State<uncompletedJobs> {
  String getMonth(int month) {
    Map<int, String> months = {
      1: "Jan",
      2: "Feb",
      3: "Mar",
      4: "Apr",
      5: "May",
      6: "Jun",
      7: "Jul",
      8: "Aug",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec",
    };
    if (months.containsKey(month)) {
      return months[month]!;
    }
    return "Invalid Month";
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    return Scaffold(
      backgroundColor: Color(0xff31384d),
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
              return const Text(
                "There are no any uncompleted jobs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            }
            days.sort((a, b) => a.compareTo(b));
            return ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  var day = days[index];
                  var joblist = jobProvider.uncompletedJobs[day]!.values.toList();

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
                            child: Text(
                              "${getMonth(day.month)}. ${day.day}/${day.year}",
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
