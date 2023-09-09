import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Job {
  String? id;

  DateTime earlyTime;
  DateTime lateTime;
  DateTime? invoiceTime;

  List<String>? pictures;

  String subCompany;
  String subContractor;
  String jobNo;
  String invoiceNumber;
  String description;

  String address;

  String postcode;
  bool completed;

  Job({
    this.invoiceTime,
    this.id,
    required this.lateTime,
    required this.completed,
    required this.subCompany,
    required this.jobNo,
    required this.invoiceNumber,
    required this.description,
    this.pictures,
    required this.earlyTime,
    required this.address,
    required this.postcode,
    required this.subContractor,
  });

  Map<String, dynamic> toMap() {
    return {
      'subcompany': subCompany,
      'jobno': jobNo,
      'invoicenumber': invoiceNumber,
      'description': description,
      'timestart': earlyTime.millisecondsSinceEpoch,
      'timefinish': lateTime.millisecondsSinceEpoch,
      'address': address,
      'postcode': postcode,
      'completed': completed,
      'subcontractor': subContractor,
    };
  }

  // complete desirialisation
  factory Job.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
      id: doc.id,
      subCompany: data['subcompany'] ?? "None",
      jobNo: data['jobno'] ?? "None",
      invoiceNumber: data["invoicenumber"] ?? "Hasn't been set yet",
      description: data["description"] ?? "None",
      earlyTime: DateTime.fromMillisecondsSinceEpoch(data["timestart"]),
      lateTime: DateTime.fromMillisecondsSinceEpoch(data["timefinish"] ?? DateTime.now().millisecondsSinceEpoch),
      address: data["address"] ?? "None",
      postcode: data["postcode"] ?? "None",
      completed: data['completed'] ?? false,
      subContractor: data["subcontractor"] ?? "You",
      invoiceTime: data["invoicetime"] != null ? DateTime.fromMillisecondsSinceEpoch(data["invoicetime"]) : null,
    );
  }
}

class Company {
  String name;
  String address;
  String city;
  String postcode;
  String phoneNumber;
  String bankName;
  String accountNumber;
  String sortCode;
  String id;
  int InvoiceCounter;

  Company(
      {required this.InvoiceCounter,
      required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.postcode,
      required this.phoneNumber,
      required this.bankName,
      required this.accountNumber,
      required this.sortCode});
  factory Company.fromDocument(dynamic data, String id) {
    return Company(
        id: id,
        InvoiceCounter: data["invoice_counter"] ?? 0,
        name: data['name'] ?? " ",
        address: data['address'] ?? " ",
        city: data['town'] ?? " ",
        postcode: data['post_code'] ?? " ",
        sortCode: data['sort_code'] ?? " ",
        phoneNumber: data['phone'] ?? " ",
        accountNumber: data['account_number'] ?? " ",
        bankName: data['bank_name'] ?? " ");
  }
}

class Services {
  String? id;
  String typeofCharge;
  String description;
  double price;
  int quantity;
  late double totalPrice;
  Services(
      {required this.description, required this.price, required this.quantity, required this.typeofCharge, this.id}) {
    totalPrice = price * quantity;
  }
  Map<String, dynamic> toMap() {
    return {
      'type': typeofCharge,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }

  // complete desirialisation
  factory Services.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Services(
        id: doc.id,
        typeofCharge: data['type'],
        description: data['description'],
        price: data['price'],
        quantity: data['quantity']);
  }
}

class rsUser {
  String companyId;
  String firstname;
  String lastname;
  rsUser({required this.companyId, required this.firstname, required this.lastname});

  factory rsUser.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return rsUser(
        companyId: data['company'] ?? "none",
        firstname: data['first_name'] ?? "Guest",
        lastname: data['last_name'] ?? "");
  }
}
