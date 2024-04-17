import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/JobList.dart';
import 'package:rsforms/Providers/jobProvider.dart';
import 'package:rsforms/Screens/Jobs/job_adder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  void launchMaps(String address) async {
    final googleUrlIOS = Uri.parse('comgooglemaps://?q=$address');
    final googleUrlAndroid = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
    try {
      if (await canLaunchUrl(googleUrlIOS)) {
        await launchUrl(googleUrlIOS, mode: LaunchMode.externalApplication);
      }
      if (await canLaunchUrl(googleUrlAndroid)) await launchUrl(googleUrlAndroid, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  String formatProviderName(String providerName) {
    if (providerName.length > 18) {
      return "${providerName.substring(0, 15)}...";
    }
    return providerName;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  //break widgets into smaller one's
  //move th jobtile into jobtile.
  //create different file for drawer
  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      // move it into different file.
      backgroundColor: const Color(0xff31384d),
      key: _key,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
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
                            bottom: 1.75,
                            child: Container(
                              width: 4.5, // increase the size of the marker
                              height: 4.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black, // color that contrasts with the cell color
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(color: Color(0xff31384c), shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Color(0x8831384c),
                        shape: BoxShape.circle,
                      ),
                    ),
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        formatButtonDecoration: BoxDecoration(color: Colors.transparent),
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                        titleTextStyle: TextStyle(fontSize: 18)),
                    shouldFillViewport: true,
                    availableGestures: AvailableGestures.all,
                    eventLoader: (day) {
                      return jobProvider.jobsCalendar[DateTime(day.year, day.month, day.day)]?.values.toList() ?? [];
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
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JobAdder(date: jobProvider.focusedDay.add(const Duration(hours: 12))),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add)),
                        const SizedBox(
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: const BoxDecoration(
                        color: Color(0xff31384d),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                    height: double.infinity,
                    width: double.infinity,
                    child: Consumer<JobProvider>(
                      builder: (context, jobprovider, child) {
                        if (jobprovider.jobsCalendar[jobprovider.selectedDay] != null &&
                            jobProvider.jobsCalendar[jobprovider.selectedDay]!.isNotEmpty) {
                          var joblist = jobProvider.jobsCalendar[jobprovider.selectedDay]!.values.toList();
                          joblist.sort((a, b) => a.earlyTime.compareTo(b.earlyTime));
                          return JobList(
                            context: context,
                            joblist: joblist,
                            scrollable: true,
                          );
                        } else {
                          return const Column(
                            children: [
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
      ),
    );
  }
}
