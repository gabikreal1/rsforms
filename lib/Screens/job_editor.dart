// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../Classes/job.dart';

class JobEditor extends StatefulWidget {
  Job job;
  JobEditor({super.key, required this.job});
  @override
  State<JobEditor> createState() => _JobEditorState();
}

class _JobEditorState extends State<JobEditor> {
  late final TextEditingController _cityController =
      TextEditingController(text: widget.job.city);
  bool cityChange = false;

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  void UpdateCity() {
    setState(() {
      if (cityChange) {
        widget.job.city = _cityController.text.trim();
      }
      print("lol");
      cityChange = !cityChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0, top: 2),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xff31384d)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 2),
                            child: Text(
                              "City",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: cityChange
                                    ? Container(
                                        height: 40,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(2),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                          controller: _cityController,
                                          onFieldSubmitted: (value) =>
                                              UpdateCity(),
                                        ),
                                      )
                                    : Text(
                                        "${widget.job.city}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                            IconButton(
                                onPressed: () {
                                  UpdateCity();
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "address: ${widget.job.address}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "postcode: ${widget.job.postcode}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "description: ${widget.job.description}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "job number: ${widget.job.jobNo}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "time: ${formatTime(widget.job.time)}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
