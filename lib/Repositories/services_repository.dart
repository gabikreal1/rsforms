import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Repositories/custom_socket.dart';

import '../Services/config_service.dart';

class ServicesRepository {
  static late CustomSocketWrapper socketWrapper;

  static final StreamController<List<Services?>?> _serviceStreamSocket = StreamController<List<Services?>?>();

  static Stream<List<Services?>?> get serviceStream => _serviceStreamSocket.stream;

  static initialize() {
    socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/services");
  }

  static void _addServiceDataToStream(dynamic data) {
    List<Services?> response = [];
    for (var doc in data) {
      response.add(Services.fromJson(doc));
    }
    _serviceStreamSocket.add(response);
  }

  static listenToServiceUpdates(Job job) {
    if (job.id == null) {
      return;
    }

    ///Initial fetch of data.
    socketWrapper.socket.emitWithAck(
      "findAllServices",
      job.id,
      ack: (data) => _addServiceDataToStream(data),
    );

    //Because we're not assigned to room by userId on serverside.
    //We need to get assigned to room from by passing jobId.
    socketWrapper.socket.emit("joinRoom", job.id!);

    ///Listening events
    socketWrapper.socket.on(
      "serviceUpdated",
      (data) => _addServiceDataToStream(data),
    );
    socketWrapper.socket.on(
      "serviceCreated",
      (data) => _addServiceDataToStream(data),
    );
  }

  static stopListeningToUpdates() {
    /// We need to manually exit the rooms and deattach the listeners
    socketWrapper.socket.emit(
      "leaveRoom",
    );
    socketWrapper.socket.clearListeners();
  }

  static createService(Services service) {
    socketWrapper.socket.emit("createService", service);
  }
}
