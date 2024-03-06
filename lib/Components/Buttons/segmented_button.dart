import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedButtonData {
  final dynamic value;
  final String title;
  final IconData Icon;

  const SegmentedButtonData({required this.value, required this.title, required this.Icon});
}

class DoubleSegmentedButton extends StatefulWidget {
  final List<SegmentedButtonData> values;
  final Function(dynamic value) select;
  final String title;
  const DoubleSegmentedButton({
    super.key,
    required this.values,
    required this.select,
    required this.title,
  });

  @override
  State<DoubleSegmentedButton> createState() => _DoubleSegmentedButtonState();
}

class _DoubleSegmentedButtonState extends State<DoubleSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    dynamic _selectedValue;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SegmentedButton(
              selectedIcon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              segments: <ButtonSegment<dynamic>>[
                ButtonSegment<dynamic>(
                    value: widget.values[0].value,
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.values[0].title,
                        style: TextStyle(
                            fontSize: 16,
                            color: _selectedValue == widget.values[0].value ? Colors.white : Colors.black),
                      ),
                    ),
                    icon: Icon(widget.values[0].Icon)),
                ButtonSegment<dynamic>(
                    value: widget.values[1].value,
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.values[1].title,
                        style: TextStyle(
                            fontSize: 16,
                            color: _selectedValue == widget.values[1].value ? Colors.white : Colors.black),
                      ),
                    ),
                    icon: Icon(widget.values[1].Icon)),
              ],
              onSelectionChanged: (value) {
                setState(() {
                  _selectedValue = value;
                  widget.select(value);
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              selected: <dynamic>{_selectedValue},
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class TripleSegmentedButton extends StatefulWidget {
  final List<SegmentedButtonData> values;
  final Function(dynamic value) select;
  final String title;
  const TripleSegmentedButton({
    super.key,
    required this.values,
    required this.select,
    required this.title,
  });

  @override
  State<TripleSegmentedButton> createState() => _TripleSegmentedButtonState();
}

class _TripleSegmentedButtonState extends State<TripleSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    dynamic _selectedValue;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: SegmentedButton(
                selectedIcon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
                segments: <ButtonSegment<dynamic>>[
                  ButtonSegment<dynamic>(
                      value: widget.values[0].value,
                      label: Text(
                        widget.values[0].title,
                        style: TextStyle(
                            fontSize: 15,
                            color: _selectedValue == widget.values[0].value ? Colors.white : Colors.black),
                      ),
                      icon: Icon(
                        widget.values[0].Icon,
                        size: 15,
                      )),
                  ButtonSegment<dynamic>(
                      value: widget.values[1].value,
                      label: Text(
                        widget.values[1].title,
                        style: TextStyle(
                            fontSize: 15,
                            color: _selectedValue == widget.values[1].value ? Colors.white : Colors.black),
                      ),
                      icon: Icon(
                        widget.values[1].Icon,
                        size: 15,
                      )),
                  ButtonSegment<dynamic>(
                      value: widget.values[2].value,
                      label: Text(
                        widget.values[2].title,
                        style: TextStyle(
                            fontSize: 15,
                            color: _selectedValue == widget.values[2].value ? Colors.white : Colors.black),
                      ),
                      icon: Icon(
                        widget.values[2].Icon,
                        size: 15,
                      )),
                ],
                onSelectionChanged: (value) {
                  setState(() {
                    _selectedValue = value.first;
                    widget.select(value.first);
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                selected: <dynamic>{_selectedValue},
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
