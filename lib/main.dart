import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import 'package:rsforms/Providers/jobProvider.dart';
import 'package:rsforms/Screens/calendar.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Company company =
      Company.fromDocument(await FirebaseFirestore.instance.collection('companies').doc('p7NxaqeggifpoF0R9aGS').get());

  runApp(MyApp(
    company: company,
  ));
}

class MyApp extends StatelessWidget {
  Company company;
  MyApp({super.key, required this.company});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JobProvider>(create: (context) {
          return JobProvider(company);
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RsForms',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Calendar(),
      ),
    );
  }
}
