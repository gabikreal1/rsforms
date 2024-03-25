import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/firebase_options.dart';
import 'Screens/Authrorisation/auth_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  User? value = await FirebaseAuth.instance.authStateChanges().first;
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
  log(token);

  runApp(MyApp(
    authState: value,
  ));
}

class MyApp extends StatelessWidget {
  User? authState;
  MyApp({super.key, required this.authState});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Provider<User?>(
      create: (context) {
        return authState;
      },
      child: MaterialApp(
        title: 'RsForms',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthHandler(),
      ),
    );
  }
}
