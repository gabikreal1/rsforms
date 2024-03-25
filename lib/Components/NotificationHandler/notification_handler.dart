import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotifcationHandler extends StatefulWidget {
  const NotifcationHandler({super.key});

  @override
  State<NotifcationHandler> createState() => _NotifcationHandlerState();
}

class _NotifcationHandlerState extends State<NotifcationHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
