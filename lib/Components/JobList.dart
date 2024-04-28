import 'dart:ffi';

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
  final BuildContext context;
  final bool? showPrice;
  const JobList({super.key, required this.joblist, required this.scrollable, this.showPrice, required this.context});

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
      return;
    }
  }

  void callPhoneNumber(String phoneNumber) async {
    Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  String formatProviderName(String providerName) {
    if (providerName.length > 21) {
      return "${providerName.substring(0, 18)}...";
    }
    return providerName;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: widget.scrollable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: widget.joblist.length,
      itemBuilder: (context, index) {
        final job = widget.joblist[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Material(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.only(top: 7.00, bottom: (widget.showPrice ?? false) ? 6.00 : 0),
              child: ListTile(
                onTap: () async {
                  //todo:rerouting
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobEditor(
                        jobId: job.id!,
                        day: DateTime(job.startTime.year, job.startTime.month, job.startTime.day),
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: const Text("What action do you want to take?"),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () async {
                              Navigator.pop(context);
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      "Confirm Deletion",
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                          onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Provider.of<JobProvider>(widget.context, listen: false).deleteJob(job);
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
                            child: const Text("Delete"),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: const Text("Cancel"),
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
                          formatProviderName(job.client),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Spacer(),
                        if (widget.showPrice == true)
                          Text(
                            '+£${job.price?.toStringAsFixed(2) ?? 0}',
                            style: TextStyle(color: Colors.green[600], fontSize: 13, fontWeight: FontWeight.bold),
                          )
                        else if (int.tryParse(job.invoiceNumber) != null && job.invoiceNumber != "-1")
                          Text(
                            'Invoice #${job.invoiceNumber}',
                            style: TextStyle(color: Colors.green[600], fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        else if (job.completed == true)
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[600],
                            ),
                          )
                        else
                          Text('${formatTime(job.startTime)} - ${formatTime(job.endTime)}',
                              style: TextStyle(
                                  color: job.startTime.difference(DateTime.now()).inHours < 3
                                      ? Colors.yellow[800]
                                      : Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        job.address,
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          job.postcode,
                          style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          '${job.agent.toUpperCase()} ',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    if ((widget.showPrice == false || widget.showPrice == null) &&
                        (job.postcode.isNotEmpty || job.contactNumber.isNotEmpty))
                      // ExpandableNotifier(
                      //   child: Expandable(
                      //       collapsed: ExpandableButton(child: Icon(Icons.keyboard_arrow_down)),
                      //       expanded:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (job.postcode.isNotEmpty)
                            SizedBox(
                              width: 120,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                    visualDensity: VisualDensity(
                                      vertical: -2,
                                    ),
                                    alignment: Alignment.centerLeft),
                                onPressed: () => launchMaps(job.postcode),
                                icon: Icon(
                                  Icons.navigation_outlined,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                label: Text(
                                  "Navigate",
                                  softWrap: false,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          if (job.contactNumber.isNotEmpty)
                            SizedBox(
                              width: 150,
                              child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                      visualDensity: VisualDensity(vertical: -2), alignment: Alignment.centerLeft),
                                  onPressed: () => callPhoneNumber(job.contactNumber),
                                  icon: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  label: Text(
                                    "${job.contactNumber} ",
                                    style: TextStyle(fontSize: 13),
                                    softWrap: false,
                                  )),
                            )
                        ],
                        // )),
                      )
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
