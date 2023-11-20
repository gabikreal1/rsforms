// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  bool obscureText;
  final onSubm;
  final bool? autoFocus;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.autoFocus,
    this.onSubm,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _passwordVisibility = true;

  @override
  void initstate() {
    _passwordVisibility = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        autofocus: widget.autoFocus ?? false,
        onFieldSubmitted: (value) => widget.onSubm ?? {},
        obscureText:
            widget.obscureText ? _passwordVisibility : widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            labelText: widget.hintText,
            // Here is key idea
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisibility
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                  )
                : null),
      ),
    );
  }
}
