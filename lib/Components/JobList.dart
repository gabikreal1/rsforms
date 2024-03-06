import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/jobModel.dart';
import '../Providers/jobProvider.dart';
import '../Screens/Jobs/job_editor.dart';

class JobList extends StatefulWidget {
  final List<Job> joblist;
  final bool scrollable;
  final bool? showPrice;
  const JobList({super.key, required this.joblist, required this.scrollable, this.showPrice});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  //launch google maps
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: widget.scrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(),
      itemCount: widget.joblist.length,
      itemBuilder: (context, index) {
        final job = widget.joblist[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Material(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ListTile(
                onTap: () async {
                  //todo:rerouting
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobEditor(
                        jobId: job.id!,
                        day: DateTime(job.earlyTime.year, job.earlyTime.month, job.earlyTime.day),
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: Text("What actions do you want to take?"),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              launchMaps(job.postcode);
                            },
                            child: Text("✈️ Navigate"),
                          ),
                          CupertinoActionSheetAction(
                            child: Text("Edit"),
                            onPressed: () async {
                              Navigator.pop(context);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobEditor(
                                    jobId: job.id!,
                                    day: DateTime(job.earlyTime.year, job.earlyTime.month, job.earlyTime.day),
                                  ),
                                ),
                              );
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text("Delete"),
                            onPressed: () async {
                              Navigator.pop(context);
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      "Confirm Deletion",
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                          onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Provider.of<JobProvider>(context, listen: false).deleteJob(job.id!);
                                          Navigator.pop(context);
                                        },
                                        isDestructiveAction: true,
                                        child: const Text("Delete "),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            isDestructiveAction: true,
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${formatProviderName(job!.subCompany)}',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
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
                                : Colors.yellow, // color that contrasts with the cell color
                          ),
                        ),
                        Spacer(),
                        widget.showPrice ?? false == true
                            ? Text(
                                '+£${job.price?.toStringAsFixed(2) ?? 0}',
                                style: TextStyle(color: Colors.green[600], fontSize: 13, fontWeight: FontWeight.bold),
                              )
                            : Text('${formatTime(job.earlyTime)} - ${formatTime(job.lateTime)}',
                                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${job.address}',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${job.postcode} ',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        Spacer(),
                        Text(
                          '${job.subContractor.toUpperCase()} ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
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
  }
}
