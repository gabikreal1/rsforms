import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsforms/APIs/auth_service.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import 'package:rsforms/Providers/jobProvider.dart';
import 'package:rsforms/Providers/userProvider.dart';
import 'package:rsforms/Screens/calendar.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Screens/company_adder.dart';
import 'package:rsforms/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

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

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider(create: (context) {
            return UserProvider();
          }, builder: (context, child) {
            if (Provider.of<UserProvider>(context, listen: false).user.companyId == "0") {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'RsForms',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: CompanyAdder(),
              );
            }
            ;
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
                    update: (context, company, _) {
                      _!.setCompany(company.company);
                      return _;
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
                  home: Calendar(),
                ),
              ),
            );
          });
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RsForms',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: Builder(builder: (context) {
              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child:
                                        Container(height: 40, width: 40, child: CircularProgressIndicator.adaptive()));
                              });
                          AuthService().signInWithGoogle();
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_4,
                            ),
                            Spacer(),
                            Text("LOGIN WITH GOOGLE")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
