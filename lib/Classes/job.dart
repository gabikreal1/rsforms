import 'package:flutter/material.dart';

class Job {
  DateTime time;
  Company company;
  List<Services>? services;
  String subCompany;
  String jobNo;
  int invoiceNumber;
  String description;
  List<String>? pictures;
  double? totalPrice;
  String address;
  String city;
  String postcode;
  bool? completed = false;

  Job(
      {this.completed,
      required this.subCompany,
      required this.jobNo,
      required this.invoiceNumber,
      required this.description,
      this.pictures,
      this.totalPrice,
      required this.time,
      required this.company,
      this.services,
      required this.address,
      required this.city,
      required this.postcode});

  void updateTotalPrice() {
    totalPrice = 0;
    for (var i = 0; i < services!.length; i++) {
      totalPrice = totalPrice! + services![i].totalPrice;
    }
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

  Company(
      {required this.name,
      required this.address,
      required this.city,
      required this.postcode,
      required this.phoneNumber,
      required this.bankName,
      required this.accountNumber,
      required this.sortCode});
}

class Services {
  String typeofCharge;
  String description;
  double price;
  int quantity;
  double totalPrice;
  Services(this.totalPrice,
      {required this.description,
      required this.price,
      required this.quantity,
      required this.typeofCharge}) {
    totalPrice = price * quantity;
  }
}
