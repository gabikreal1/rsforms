import 'package:cloud_firestore/cloud_firestore.dart';

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

  DateTime earlyTime;
  DateTime lateTime;
  DateTime? lastUpdated;
  bool? removed;
  double? price;


  String contactNumber;
  List<String>? pictures;

  String subCompany;
  String subContractor;
  String jobNo;
  String invoiceNumber;
  String description;
  String YHS;
  String address;

  String postcode;
  bool completed;

  Job(
      {
      this.price,
      this.id,
      required this.lateTime,
      required this.completed,
      required this.subCompany,
      required this.jobNo,
      required this.invoiceNumber,
      required this.description,
      this.pictures,
      required this.contactNumber,
      required this.earlyTime,
      required this.address,
      required this.postcode,
      required this.subContractor,
      required this.YHS,
      this.lastUpdated,
      this.removed});

  Map<String, dynamic> toMap() {
    return {
      'contactnumber': contactNumber,
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
      'YHS': YHS,
      'lastupdated': lastUpdated ?? DateTime.now(),
      'removed': removed ?? false,
      'price': price ?? 0.0,
    };
  }

  factory Job.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
        id: doc.id,
        removed: data['removed'] ?? false,
        lastUpdated: data['lastupdated'] != null ? data["lastupdated"].toDate() : null,
        contactNumber: data['contactnumber'] ?? "0",
        subCompany: data['subcompany'] ?? "None",
        jobNo: data['jobno'] ?? "None",
        invoiceNumber: data["invoicenumber"] ?? "Hasn't been set yet",
        description: data["description"] ?? "None",
        earlyTime: DateTime.fromMillisecondsSinceEpoch(data["timestart"]),
        lateTime: DateTime.fromMillisecondsSinceEpoch(data["timefinish"] ?? DateTime.now().millisecondsSinceEpoch),
        address: data["address"] ?? "None",
        YHS: data["YHS"] ?? "None",
        postcode: data["postcode"] ?? "None",
        completed: data['completed'] ?? false,
        subContractor: data["subcontractor"] ?? "You",

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

  Company(
      {required this.InvoiceCounter,
      this.id,
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

class RsUser {
  String companyId;
  String firstname;
  String lastname;
  RsUser({required this.companyId, required this.firstname, required this.lastname});

  factory RsUser.fromdocument(DocumentSnapshot doc) {
    if (doc.data() == null) {
      return RsUser(companyId: "-1", firstname: "loh", lastname: "lohovich");
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RsUser(
        companyId: data['company'] ?? "0", firstname: data['first_name'] ?? "Guest", lastname: data['last_name'] ?? "");
  }
}
