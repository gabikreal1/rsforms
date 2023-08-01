import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Models/jobModel.dart';

import '../Providers/jobProvider.dart';

class JobAdder extends StatelessWidget {
  const JobAdder({super.key});

  @override
  Widget build(BuildContext context) {
    final jobprovider = Provider.of<JobProvider>(context, listen: false);
    return const Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: []),
        ),
      )),
    );
  }
}
