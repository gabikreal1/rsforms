// ignore_for_file: prefer_null_aware_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotRequiredJobDetails {
  String? subCompany;
  String? subContractor;
  String? jobNo;
  String? invoiceNumber;
  String? description;
  String? YHS;
  String? address;
  String? postcode;
  double? price;
  String? contactNumber;
}

class Job {
  String? id;

  DateTime startTime;
  DateTime endTime;
  DateTime? lastUpdated;
  bool? removed;
  double? price;

  String contactNumber;
  List<String>? pictures;

  String client;
  String agent;
  String jobNo;
  String invoiceNumber;
  String description;
  String YHS;
  String address;

  String postcode;
  bool completed;

  Job(
      {this.price,
      this.id,
      required this.endTime,
      required this.completed,
      required this.client,
      required this.jobNo,
      required this.invoiceNumber,
      required this.description,
      this.pictures,
      required this.contactNumber,
      required this.startTime,
      required this.address,
      required this.postcode,
      required this.agent,
      required this.YHS,
      this.lastUpdated,
      this.removed});

  Map<String, dynamic> toMap() {
    return {
      'contactnumber': contactNumber,
      'subcompany': client,
      'jobno': jobNo,
      'invoicenumber': invoiceNumber,
      'description': description,
      'timestart': startTime.millisecondsSinceEpoch,
      'timefinish': endTime.millisecondsSinceEpoch,
      'address': address,
      'postcode': postcode,
      'completed': completed,
      'subcontractor': agent,
      'YHS': YHS,
      'lastupdated': lastUpdated ?? DateTime.now(),
      'removed': removed ?? false,
      'price': price ?? 0.0,
    };
  }

  factory Job.fromJson(data) {
    return Job(
      id: data["id"],
      client: data["client"] ?? "",
      agent: data["agent"] ?? "",
      address: data["address"] ?? "",
      postcode: data["postcode"] ?? "",
      description: data["description"] ?? "",
      contactNumber: data["contactNumber"] ?? "",
      startTime: DateTime.fromMillisecondsSinceEpoch(data["timestart"] ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(data["timefinish"] ?? 0),
      completed: data["isCompleted"] ?? false,
      price: data["price"] ?? 0.0,
      invoiceNumber: (data["invoiceNumber"] ?? -1).toString(),
      YHS: data["YHS"] ?? "None",
      jobNo: data["jobNo"] ?? "None",
      lastUpdated: data["lastUpdatedTime"] != null ? data["lastUpdatedTime"].toDate() : null,
      removed: data["removed"] ?? false,
    );
  }

  factory Job.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
        id: doc.id,
        removed: data['removed'] ?? false,
        lastUpdated: data['lastupdated'] != null ? data["lastupdated"].toDate() : null,
        contactNumber: data['contactnumber'] ?? "0",
        client: data['subcompany'] ?? "None",
        jobNo: data['jobno'] ?? "None",
        invoiceNumber: data["invoicenumber"] ?? "Hasn't been set yet",
        description: data["description"] ?? "None",
        startTime: DateTime.fromMillisecondsSinceEpoch(data["timestart"]),
        endTime: DateTime.fromMillisecondsSinceEpoch(data["timefinish"] ?? DateTime.now().millisecondsSinceEpoch),
        address: data["address"] ?? "None",
        YHS: data["YHS"] ?? "None",
        postcode: data["postcode"] ?? "None",
        completed: data['completed'] ?? false,
        agent: data["subcontractor"] ?? "You",
        price: data['price'] ?? 0.0);
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
  String? id;
  int InvoiceCounter;
  List<RsUser?>? users;

  Company(
      {required this.InvoiceCounter,
      this.id,
      this.users,
      required this.name,
      required this.address,
      required this.city,
      required this.postcode,
      required this.phoneNumber,
      required this.bankName,
      required this.accountNumber,
      required this.sortCode});

  Map<String, dynamic> toMap() {
    return {
      'account_number': accountNumber,
      'address': address,
      'bank_name': bankName,
      'invoice_counter': InvoiceCounter,
      'name': name,
      'phone': phoneNumber,
      'post_code': postcode,
      'sort_code': sortCode,
      'town': city,
    };
  }

  // For Firebase
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

  factory Company.fromJson(dynamic data) {
    List<RsUser?>? _users;

    if (data["users"] != null) {
      _users = List.empty(growable: true);
      for (var user in data["users"]) {
        _users.add(RsUser.fromdocument(user));
      }
    }

    return Company(
      id: data["id"] ?? "-1",
      InvoiceCounter: data["invoiceCounter"] ?? 0,
      name: data["name"] ?? "",
      address: data["address"] ?? "",
      city: data["city"] ?? "",
      postcode: data["postcode"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      bankName: data["bankName"] ?? "",
      accountNumber: data["accountNumber"],
      sortCode: data["sortCode"] ?? "",
      users: _users,
    );
  }
}

class Services {
  String? id;
  String jobId;
  String typeofCharge;
  String description;
  double price;
  int quantity;
  late double totalPrice;
  Services(
      {required this.description,
      required this.price,
      required this.quantity,
      required this.typeofCharge,
      this.id,
      required this.jobId}) {
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
  factory Services.fromJson(dynamic data) {
    return Services(
        id: data["id"],
        jobId: data["jobId"],
        typeofCharge: data['type'],
        description: data['description'],
        price: data['price'],
        quantity: data['quantity']);
  }

  factory Services.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Services(
        id: doc.id,
        jobId: "none",
        typeofCharge: data['type'],
        description: data['description'],
        price: data['price'],
        quantity: data['quantity']);
  }
}

class RsUser {
  String? id;
  String? fcmToken;
  String companyId;
  String email;
  RsUser({required this.companyId, required this.email, this.id, this.fcmToken});

  factory RsUser.fromJson(dynamic data) {
    String _companyId = "";
    if (data["company"] != null) {
      String _companyId = Company.fromJson(data["company"]).id ?? "";
    }
    return RsUser(companyId: _companyId, email: data["email"]);
  }

  factory RsUser.fromdocument(DocumentSnapshot doc) {
    if (doc.data() == null) {
      return RsUser(companyId: "-1", email: "none");
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RsUser(companyId: data['company'] ?? "0", email: "none");
  }
}
