import 'package:flutter/material.dart';

class AuthErrorDialog extends StatelessWidget {
  final String errorMessage;
  const AuthErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    var tertiaryColor = Theme.of(context).colorScheme.tertiary;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryColor),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Exit",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
