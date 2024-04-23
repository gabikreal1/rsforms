import 'dart:async';

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

  static late CustomSocketWrapper socketWrapper;
  static final StreamController<Company?> _companyStreamSocket = StreamController<Company>();
  static Stream<Company?>? get companyStream => _companyStreamSocket.stream;

  static _addCompanyDataToStream(dynamic data) {
    _companyStreamSocket.add(Company.fromJson(data));
  }

  ///"${ConfigService.defaultApiPath}/companies"
  static initialize() {
    socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/companies");
  }

  /// Fetches the initial details and puts it in stream and then keeps it updated
  static listenToCompanyUpdates() {
    socketWrapper.socket.emitWithAck(
      "findOneCompany",
      "",
      ack: (data) => _addCompanyDataToStream(data),
    );

    socketWrapper.socket.on(
      "companyUpdated",
      (data) => _addCompanyDataToStream(data),
    );
  }

  static createCompany(Company company) {
    socketWrapper.socket.emitWithAck(
      "createCompany",
      company.toMap(),
      ack: (data) => _addCompanyDataToStream(data),
    );
  }

  static updateCompany(Company company) async {
    socketWrapper.socket.emit(
      "updateCompany",
      company.toMap(),
    );
  }

  static joinCompany(String shareCode) {
    socketWrapper.socket.emit(
      "joinCompany",
      shareCode,
    );
  }

  static removeUserFromCompany(RsUser userToRemove) {
    socketWrapper.socket.emit(
      "removeUser",
      userToRemove.email,
    );
  }
}
