import '../Models/jobModel.dart';

class Invoice {
  Company company;
  Job job;
  List<Services> services;
  DateTime? dateSubmitted = DateTime.now();

  Invoice({required this.company, this.dateSubmitted, required this.job, required this.services});
}
