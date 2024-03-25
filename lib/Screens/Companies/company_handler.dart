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
        return UserProvider();
      },
      builder: (context, child) {
        return Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.user.companyId == "-1") {
              return CompanyHandlerScreen();
            } else if (provider.user.companyId == "0") {
              return Scaffold(
                body: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              );
            } else {
              return ChangeNotifierProxyProvider<UserProvider, CompanyProvider>(
                create: (context) {
                  return CompanyProvider(Provider.of<UserProvider>(context, listen: false).user);
                },
                update: (context, value, previous) {
                  previous!.setUser(value.user);
                  return previous;
                },
                builder: (context, child) => MultiProvider(
                  providers: [
                    ChangeNotifierProxyProvider<CompanyProvider, JobProvider>(
                      create: (context) {
                        return JobProvider(Provider.of<CompanyProvider>(context, listen: false).company);
                      },
                      update: (context, company, previous) {
                        previous!.setCompany(company.company);
                        return previous;
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
                ),
              );
            }
          },
        );
      },
    );
  }
}
