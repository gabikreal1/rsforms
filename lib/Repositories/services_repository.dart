import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Repositories/custom_socket.dart';

import '../Services/config_service.dart';

class ServicesRepository {
  static CustomSocketWrapper? socketWrapper;

  static final StreamController<List<Services?>?> _serviceStreamSocket = StreamController<List<Services?>?>.broadcast();

  static Stream<List<Services?>?> get serviceStream => _serviceStreamSocket.stream;

  static void _addServiceDataToStream(dynamic data) {
    List<Services?> response = [];
    for (var doc in data) {
      response.add(Services.fromJson(doc));
    }
    _serviceStreamSocket.add(response);
  }

  static listenToServiceUpdates(String jobId) async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken(true);
    socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/services", token!);

    ///Initial fetch of data.
    socketWrapper!.socket.emitWithAck(
      "findAllServices",
      jobId,
      ack: (data) => _addServiceDataToStream(data),
    );

    ///Because we're not assigned to room by userId on serverside.
    ///We need to get assigned to room by passing jobId.
    socketWrapper!.socket.emit("joinRoom", jobId);

    ///Listening events
    socketWrapper!.socket.on(
      "serviceUpdated",
      (data) => _addServiceDataToStream(data),
    );
    socketWrapper!.socket.on(
      "serviceCreated",
      (data) => _addServiceDataToStream(data),
    );

    socketWrapper!.socket.on(
      "serviceRemoved",
      (data) => _addServiceDataToStream(data),
    );
  }

  static stopListeningToUpdates() {
    /// We need to manually exit the rooms and deattach the listeners
    socketWrapper!.socket.emit(
      "leaveRoom",
    );
    socketWrapper!.socket.clearListeners();
  }

  static createService(Services service) {
    socketWrapper!.socket.emit("createService", service.toMap());
  }

  static updateService(Services service) {
    socketWrapper!.socket.emit("updateService", service.toMap());
  }

  static removeService(String serviceID) {
    socketWrapper!.socket.emit("removeService", serviceID);
  }
}
