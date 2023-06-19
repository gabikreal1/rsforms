// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rsforms/Screens/job_editor.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rsforms/Classes/job.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Calendar extends StatefulWidget {
  Company company;
  Calendar({super.key, required this.company});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Job> _selectedJobs = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void initState() {
    super.initState();
    _jobs = {
      DateTime(2023, 6, 22): [
        Job(
            subCompany: "Your Home Support",
            jobNo: "Sub/40379",
            invoiceNumber: 1560,
            description: "Made something",
            time: DateTime(2023, 6, 22, 13, 25),
            company: widget.company,
            address: "8 Cheshire Walk",
            city: "Basildon",
            postcode: "SS14 3TW"),
        Job(
            subCompany: "Your Home Support",
            jobNo: "Sub/40379",
            invoiceNumber: 1560,
            description: "Made something",
            time: DateTime(2023, 6, 22, 10, 25),
            company: widget.company,
            address: "Rooksdown House, Southern Rd",
            city: "Basingstoke",
            postcode: "RG21 3DZ",
            completed: true),
        Job(
            subCompany: "National Lock and Safe",
            jobNo: "Sub/40379",
            invoiceNumber: 1560,
            description: "Fixed the door",
            time: DateTime(2023, 6, 22, 16, 35),
            company: widget.company,
            address: "79 Riverside Close",
            city: "London",
            postcode: "E5 9SR"),
        Job(
            subCompany: "RS LOCK AND SAFE",
            jobNo: "Sub/40379",
            invoiceNumber: 1560,
            description: "Fixed door handle",
            time: DateTime(2023, 6, 22, 19, 40),
            company: widget.company,
            address: "Trafalgar Square",
            city: "London",
            postcode: "WC2"),
      ],
      DateTime(2023, 6, 19): [
        Job(
          subCompany: "Your Home Support",
          jobNo: "Sub/40380",
          invoiceNumber: 1561,
          description: "Made something",
          time: DateTime(2023, 6, 19, 6, 20),
          company: widget.company,
          address: "8 Coles Green Court",
          city: "London",
          postcode: "SW1X 77HH",
          completed: true,
        )
      ],
    };
  }

  late Map<DateTime, List<Job>> _jobs;
  void _updateSelectedEvents(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedJobs =
          _jobs[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)]
                  ?.toList() ??
              [];
      _selectedJobs.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedJobs =
            _jobs[selectedDay] ?? []; // Here's where _getEventsForDay is used
      });
    }
  }

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  void launchMaps(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    try {
      await launchUrlString(googleUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog.fullscreen(
                child: Center(
                  child: Text(
                    "Creation of Jobs to be implemented",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          )
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 6,
              child: TableCalendar(
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                eventLoader: (day) {
                  return _jobs[DateTime(day.year, day.month, day.day)] ?? [];
                },
                firstDay: DateTime.utc(1990, 1, 1),
                lastDay: DateTime.utc(2040, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  _updateSelectedEvents(selectedDay);
                  _focusedDay = focusedDay;
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
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
                child: _selectedJobs.isNotEmpty
                    ? ListView.builder(
                        itemCount: _selectedJobs.length,
                        itemBuilder: (context, index) {
                          final job = _selectedJobs[index];

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
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobEditor(
                                        job: job,
                                      ),
                                    ),
                                  ),
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
                                                // Handle the option 1 action here
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('Edit'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog.fullscreen(
                                                      child: Center(
                                                        child: Text(
                                                          "Editing of Jobs to be implemented",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );

                                                // Handle the option 2 action here
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
                                            '${job.city}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            width:
                                                6, // increase the size of the marker
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (job.completed ?? false)
                                                  ? Colors.green
                                                  : Colors
                                                      .yellow, // color that contrasts with the cell color
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${formatTime(job.time)}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
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
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${job.postcode} ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${job.subCompany} ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
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
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
