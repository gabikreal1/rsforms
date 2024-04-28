// ignore_for_file: prefer_null_aware_operators

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Future updates

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
      'id': id,
      'contactNumber': contactNumber,
      'client': client,
      'jobNo': jobNo,
      'invoiceNumber': invoiceNumber,
      'description': description,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'address': address,
      'postcode': postcode,
      'isCompleted': completed,
      'agent': agent,
      'YHS': YHS,
      'lastUpdatedTime': lastUpdated?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      'removed': removed ?? false,
      'price': price ?? 0.0,
    };
  }

  Job.clone(Job job)
      : this(
          price: job.price,
          id: job.id,
          endTime: job.endTime,
          completed: job.completed,
          client: job.client,
          jobNo: job.jobNo,
          invoiceNumber: job.invoiceNumber,
          description: job.description,
          pictures: job.pictures,
          contactNumber: job.contactNumber,
          startTime: job.startTime,
          address: job.address,
          postcode: job.postcode,
          agent: job.agent,
          YHS: job.YHS,
          lastUpdated: job.lastUpdated,
          removed: job.removed,
        );

  factory Job.fromJson(data) {
    return Job(
      id: data["id"],
      client: data["client"] ?? "",
      agent: data["agent"] ?? "",
      address: data["address"] ?? "",
      postcode: data["postcode"] ?? "",
      description: data["description"] ?? "",
      contactNumber: data["contactNumber"] ?? "",
      startTime: DateTime.fromMillisecondsSinceEpoch(data["startTime"]),
      endTime: DateTime.fromMillisecondsSinceEpoch(data["endTime"]),
      completed: data["isCompleted"] ?? false,
      price: data["price"]?.toDouble() ?? 0.0,
      invoiceNumber: (data["invoiceNumber"] ?? -1).toString(),
      YHS: data["YHS"] ?? "None",
      jobNo: data["jobNo"] ?? "None",
      lastUpdated:
          data["lastUpdatedTime"] != null ? DateTime.fromMillisecondsSinceEpoch(data["lastUpdatedTime"]) : null,
      removed: data["removed"] ?? false,
    );
  }
  // For Firebase
  // factory Job.fromdocument(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return Job(
  //       id: doc.id,
  //       removed: data['removed'] ?? false,
  //       lastUpdated: data['lastupdated'] != null ? data["lastupdated"].toDate() : null,
  //       contactNumber: data['contactnumber'] ?? "0",
  //       client: data['subcompany'] ?? "None",
  //       jobNo: data['jobno'] ?? "None",
  //       invoiceNumber: data["invoicenumber"] ?? "Hasn't been set yet",
  //       description: data["description"] ?? "None",
  //       startTime: DateTime.fromMillisecondsSinceEpoch(data["timestart"]),
  //       endTime: DateTime.fromMillisecondsSinceEpoch(data["timefinish"] ?? DateTime.now().millisecondsSinceEpoch),
  //       address: data["address"] ?? "None",
  //       YHS: data["YHS"] ?? "None",
  //       postcode: data["postcode"] ?? "None",
  //       completed: data['completed'] ?? false,
  //       agent: data["subcontractor"] ?? "You",
  //       price: data['price'] ?? 0.0);
  // }
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
  String? shareCode;
  String? ownerUserId;
  int InvoiceCounter;
  List<RsUser>? users;

  Company({
    required this.InvoiceCounter,
    this.id,
    this.users,
    required this.name,
    required this.address,
    required this.city,
    required this.postcode,
    required this.phoneNumber,
    required this.bankName,
    required this.accountNumber,
    required this.sortCode,
    this.shareCode,
    this.ownerUserId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'ownerUserId': ownerUserId,
      'shareKey': shareCode,
      'accountNumber': accountNumber,
      'address': address,
      'bankName': bankName,
      'invoiceCounter': InvoiceCounter,
      'name': name,
      'phoneNumber': phoneNumber,
      'postcode': postcode,
      'sortCode': sortCode,
      'city': city,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Company.fromJson(dynamic data) {
    List<RsUser>? _users;

    if (data["users"] != null) {
      _users = List.empty(growable: true);
      for (var user in data["users"]) {
        _users.add(RsUser.fromJson(user));
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
      shareCode: data["shareKey"],
      ownerUserId: data["ownerUserId"],
      users: _users,
    );
  }
}
// For Firebase
// factory Company.fromDocument(dynamic data, String id) {
//   return Company(
//       id: id,
//       InvoiceCounter: data["invoice_counter"] ?? 0,
//       name: data['name'] ?? " ",
//       address: data['address'] ?? " ",
//       city: data['town'] ?? " ",
//       postcode: data['post_code'] ?? " ",
//       sortCode: data['sort_code'] ?? " ",
//       phoneNumber: data['phone'] ?? " ",
//       accountNumber: data['account_number'] ?? " ",
//       bankName: data['bank_name'] ?? " ");
// }

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
      'id': id,
      'type': typeofCharge,
      'description': description,
      'price': price,
      'quantity': quantity,
      'jobId': jobId,
    };
  }

  // complete desirialisation
  factory Services.fromJson(dynamic data) {
    return Services(
        id: data["id"] ?? "",
        jobId: data["jobId"] ?? "",
        typeofCharge: data['type'] ?? "",
        description: data['description'] ?? "",
        price: data['price']?.toDouble() ?? "",
        quantity: data['quantity'] ?? "");
  }
  // For Firebase
  // factory Services.fromdocument(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return Services(
  //       id: doc.id,
  //       jobId: "none",
  //       typeofCharge: data['type'],
  //       description: data['description'],
  //       price: data['price'],
  //       quantity: data['quantity']);
  // }
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
    return RsUser(companyId: _companyId, email: data["email"], id: data["id"]);
  }

  factory RsUser.fromdocument(DocumentSnapshot doc) {
    if (doc.data() == null) {
      return RsUser(companyId: "-1", email: "none");
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RsUser(companyId: data['company'] ?? "0", email: "none");
  }
}
