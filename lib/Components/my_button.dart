import 'dart:ffi';

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  final double padding;
  const MyButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.color,
      required this.padding,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class IntegratedButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  final String iconRoute;
  const IntegratedButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.iconRoute,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(children: [
          Image.asset(
            iconRoute,
            width: 30,
            height: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
