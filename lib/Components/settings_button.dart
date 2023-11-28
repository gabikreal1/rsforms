import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final IconData icon;
  const SettingsButton(
      {super.key, required this.text, this.onTap, this.color, this.textColor, this.iconColor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        enableFeedback: false,
      ),
      onPressed: onTap,
      label: Row(
        children: [
          const SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: TextStyle(
              color: textColor ?? const Color(0xff31384d),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: textColor ?? const Color(0xff31384d),
            size: 16,
          ),
        ],
      ),
      icon: Icon(
        icon,
        color: iconColor ?? const Color(0xff31384d),
        size: 20,
      ),
    );
  }
}
