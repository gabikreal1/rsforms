import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Services/auth_service.dart';
import 'package:rsforms/Services/config_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'custom_socket.dart';

class CompanyRepository {
  /*
    Company Repository Class consists of static methods, used to access the Websocket server
    and pass the data down in stream.
  */

  static late CustomSocketWrapper _socketWrapper;
  static final StreamController<Company?> _companyStreamSocket = StreamController<Company>.broadcast();
  static Stream<Company?> get companyStream => _companyStreamSocket.stream;

  static _addCompanyDataToStream(dynamic data) {
    if (data == "none") {
      _companyStreamSocket.addError("none");
      return;
    }
    print("data");
    _companyStreamSocket.add(Company.fromJson(data));
  }

  /// Fetches the initial details and puts it in stream and then keeps it updated
  static listenToCompanyUpdates() async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    log(token ?? "");
    _socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/companies", token!);

    _socketWrapper.socket.emitWithAck(
      "findOneCompany",
      "",
      ack: (data) => _addCompanyDataToStream(data),
    );

    _socketWrapper.socket.on(
      "updatedCompany",
      (data) => _addCompanyDataToStream(data),
    );
  }

  static createCompany(Company company) {
    _socketWrapper.socket.emitWithAck(
      "createCompany",
      company.toMap(),
      ack: (data) => _addCompanyDataToStream(data),
    );
  }

  static updateCompany(Company company) async {
    _socketWrapper.socket.emit(
      "updateCompany",
      company.toMap(),
    );
  }

  static incrementCompanyInvoiceCounter() async {
    Completer completer = Completer();
    _socketWrapper.socket.emitWithAck("incrementInvoiceCounter", "", ack: (data) {
      completer.complete();
    });
    await completer.future;
  }

  static joinCompany(String shareCode) {
    _socketWrapper.socket.emit(
      "joinCompany",
      shareCode,
    );
  }

  static removeUserFromCompany(String emailToRemove) {
    _socketWrapper.socket.emit(
      "removeUser",
      emailToRemove,
    );
  }

  static promoteUserToOwner(String emailToPromote) {
    _socketWrapper.socket.emit(
      "promoteUserToOwner",
      emailToPromote,
    );
  }
}
