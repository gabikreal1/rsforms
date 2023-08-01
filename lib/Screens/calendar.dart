// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Providers/jobProvider.dart';
import 'package:rsforms/Screens/job_adder.dart';
import 'package:rsforms/Screens/job_editor.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  void launchMaps(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    try {
      await launchUrlString(googleUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  String formatProviderName(String providerName) {
    if (providerName.length > 18) {
      return "${providerName.substring(0, 15)}...";
    }
    return providerName;
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: Stack(children: [
                TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: -1, // position slightly below the cell number
                          child: Container(
                            width: 5, // increase the size of the marker
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .black, // color that contrasts with the cell color
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Color(0xff31384c), shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: Color(0x8831384c), shape: BoxShape.circle),
                  ),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      formatButtonDecoration:
                          BoxDecoration(color: Colors.transparent),
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      titleTextStyle: TextStyle(fontSize: 18)),
                  shouldFillViewport: true,
                  availableGestures: AvailableGestures.all,
                  eventLoader: (day) {
                    return jobProvider
                            .jobs[DateTime(day.year, day.month, day.day)] ??
                        [];
                  },
                  firstDay: DateTime.utc(1990, 1, 1),
                  lastDay: DateTime.utc(2040, 12, 31),
                  focusedDay: jobProvider.focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(jobProvider.selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    jobProvider.setSelectedDay(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    jobProvider.setStartOfMonth(focusedDay);
                    jobProvider.setSelectedDay(focusedDay);
                  },
                ),
                Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () => {}, icon: Icon(Icons.arrow_back)),
                      Spacer(),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobAdder(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add)),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ]),
            ),
            Flexible(
              flex: 5,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: Color(0xff31384d),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  height: double.infinity,
                  width: double.infinity,
                  child: Consumer<JobProvider>(
                    builder: (context, jobprovider, child) {
                      if (jobprovider.jobs[jobprovider.selectedDay] != null &&
                          jobProvider
                              .jobs[jobprovider.selectedDay]!.isNotEmpty) {
                        return ListView.builder(
                          itemCount:
                              jobprovider.jobs[jobprovider.selectedDay]?.length,
                          itemBuilder: (context, index) {
                            final job = jobprovider
                                .jobs[jobprovider.selectedDay]![index];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: ListTile(
                                    onTap: () async {
                                      //todo:rerouting
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JobEditor(
                                            jobId: job.id,
                                            day: DateTime(
                                                job.earlyTime.year,
                                                job.earlyTime.month,
                                                job.earlyTime.day),
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(
                                                    Icons.navigation_rounded),
                                                title: Text('Navigate'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  launchMaps("${job.postcode}");
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.edit),
                                                title: Text('Edit'),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobEditor(
                                                        jobId: job.id,
                                                        day: DateTime(
                                                            job.earlyTime.year,
                                                            job.earlyTime.month,
                                                            job.earlyTime.day),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.delete),
                                                title: Text('Delete'),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Color(0xff31384d),
                                                          title: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Container(
                                                                width: 75,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Cancel "),
                                                                    Icon(Icons
                                                                        .cancel)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Provider.of<JobProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .deleteJob(
                                                                          job.id);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 75,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "Delete "),
                                                                      Icon(Icons
                                                                          .delete)
                                                                    ],
                                                                  ),
                                                                )),
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${formatProviderName(job.subCompany)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: job.completed
                                                    ? Colors.green
                                                    : Colors
                                                        .yellow, // color that contrasts with the cell color
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${formatTime(job.earlyTime)} - ${formatTime(job.lateTime)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${job.address}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${job.postcode} ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${job.subContractor} ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "There are no any jobs on this day",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
