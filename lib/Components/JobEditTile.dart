import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobEditTile extends StatefulWidget {
  String TileName;
  String TileDescription;

  Function(String value) Update;

  JobEditTile({super.key, required this.TileName, required this.TileDescription, required this.Update});

  @override
  State<JobEditTile> createState() => _JobEditTileState();
}

class _JobEditTileState extends State<JobEditTile> {
  bool change = false;
  late final TextEditingController _controller;
  final _TileKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: widget.TileDescription);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Text(
                "${widget.TileName}",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                  controller: _controller,
                  onFieldSubmitted: (value) {
                    widget.Update(value);
                  },
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MultiLineJobEditTile extends StatefulWidget {
  String TileName;
  String TileDescription;

  Function(String value) Update;
  Function()? Callback;

  MultiLineJobEditTile(
      {super.key, required this.TileName, required this.TileDescription, required this.Update, this.Callback});

  @override
  State<MultiLineJobEditTile> createState() => _MultiLineJobEditTileState();
}

class _MultiLineJobEditTileState extends State<MultiLineJobEditTile> {
  bool change = false;
  late final TextEditingController _controller;
  final _TileKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: widget.TileDescription);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Text(
                "${widget.TileName}",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: change
                      ? Form(
                          key: _TileKey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(2),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                            controller: _controller,
                            maxLines: null,
                            onFieldSubmitted: (value) {
                              if (_TileKey.currentState != null) {
                                if (_TileKey.currentState!.validate() && change) {
                                  widget.Update!(value);
                                }
                                if (_TileKey.currentState!.validate()) {
                                  setState(() {
                                    change = !change;
                                  });
                                }
                              }
                            },
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (widget.Callback != null) {
                              widget.Callback!();
                            }
                          },
                          child: (widget.Callback == null)
                              ? SelectableText(
                                  widget.TileDescription,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              : Text(
                                  widget.TileDescription,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )),
                ),
                IconButton(
                  onPressed: () {
                    if (_TileKey.currentState != null) {
                      if (_TileKey.currentState!.validate() && change) {
                        widget.Update!(_controller.text.trim());
                      }
                      if (_TileKey.currentState!.validate()) {
                        setState(() {
                          change = !change;
                        });
                      }
                    } else {
                      setState(() {
                        change = !change;
                      });
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JobTimeEditTile extends StatefulWidget {
  String TileName;
  DateTime date;
  Function(int datestamp) Update;
  JobTimeEditTile({
    super.key,
    required this.date,
    required this.TileName,
    required this.Update,
  });

  @override
  State<JobTimeEditTile> createState() => _JobTimeEditTileState();
}

class _JobTimeEditTileState extends State<JobTimeEditTile> {
  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0'); // padLeft will add a '0' if minute is less than 10
    return '$hour:$minute';
  }

  // refactorshow modal popup is duplicated
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Text(
                "${widget.TileName}",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  child: Text(
                    "${formatTime(widget.date)}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: [
                          SizedBox(
                            height: 180,
                            child: CupertinoDatePicker(
                              initialDateTime: widget.date,
                              use24hFormat: true,
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  widget.date = newTime;
                                });
                              },
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(
                            "Done",
                          ),
                          onPressed: () {
                            widget.Update(widget.date.millisecondsSinceEpoch);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            actions: [
                              SizedBox(
                                height: 180,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  initialDateTime: widget.date,
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (DateTime newTime) {
                                    setState(() {
                                      widget.date = newTime;
                                    });
                                  },
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  color: Color(0xff31384d),
                                ),
                              ),
                              onPressed: () {
                                widget.Update(widget.date.millisecondsSinceEpoch);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
