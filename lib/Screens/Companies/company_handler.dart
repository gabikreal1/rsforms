import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Screens/Companies/company_adder.dart';
import 'package:rsforms/Screens/Companies/company_handler_screen.dart';

import '../../Providers/PictureProvider.dart';
import '../../Providers/companyProvider.dart';
import '../../Providers/jobProvider.dart';
import '../../Providers/userProvider.dart';

import '../pageview_controller.dart';

class CompanyHandler extends StatefulWidget {
  const CompanyHandler({super.key});

  @override
  State<CompanyHandler> createState() => _CompanyHandlerState();
}

class _CompanyHandlerState extends State<CompanyHandler> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return CompanyProvider();
      },
      builder: (context, child) {
        return Consumer<CompanyProvider>(
          builder: (context, provider, child) {
            if (provider.company.id == "0") {
              return Scaffold(
                body: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              );
            } else if (provider.company.id == "-1" ||
                (provider.company.users != null &&
                    provider.company.users!
                        .where((element) => element.id == FirebaseAuth.instance.currentUser?.uid)
                        .isEmpty)) {
              return CompanyHandlerScreen();
            } else {
              return MultiProvider(
                providers: [
                  ChangeNotifierProxyProvider<CompanyProvider, JobProvider>(
                    create: (context) {
                      return JobProvider();
                    },
                    update: (context, company, previous) {
                      return previous!;
                    },
                  ),
                  ChangeNotifierProvider<PictureProvider>(
                    create: (context) {
                      return PictureProvider();
                    },
                  )
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'RsForms',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  home: const PageviewControll(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
