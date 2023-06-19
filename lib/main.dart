import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsforms/Classes/job.dart';
import 'package:rsforms/Screens/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Company company = Company(
        name: "RS LOCK AND SAFE",
        address: "109 Cropley Court Cavendish street",
        city: "London",
        postcode: "N1 7HH",
        phoneNumber: "07946031981",
        bankName: "Barclays Bank",
        accountNumber: "03423573",
        sortCode: "20-32-06");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RsForms',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Calendar(
        company: company,
      ),
    );
  }
}
