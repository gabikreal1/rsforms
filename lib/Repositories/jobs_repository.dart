import 'dart:async';
import 'dart:ffi';

import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Repositories/custom_socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../Services/auth_service.dart';
import '../Services/config_service.dart';

class JobRepository {
  /*
    Same as CompanyRepository, but for jobs
  */

  static late CustomSocketWrapper socketWrapper;

  /// As we will usually fetch multiple jobs, the stream consists of List<Job>
  static final StreamController<List<Job?>?> _jobStreamSocket = StreamController<List<Job?>?>();

  static Stream<List<Job?>?>? get jobStream => _jobStreamSocket.stream;

  static initialize() async {
    socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/jobs");
  }

  ///Adds data to a stream
  static void _addJobDataToStream(dynamic data) {
    List<Job?> response = [];
    for (var doc in data) {
      response.add(Job.fromJson(doc));
    }
    _jobStreamSocket.add(response);
  }

  /// Fetches initial data and adds it to the stream and then listens to updates
  static listenToJobUpdates(Long lastUpdated) {
    socketWrapper.socket.emitWithAck(
      "lastUpdatedJobs",
      lastUpdated,
      ack: (data) => _addJobDataToStream(data),
    );

    socketWrapper.socket.on(
      "createdJob",
      (data) => _addJobDataToStream(data),
    );

    socketWrapper.socket.on(
      "updatedJob",
      (data) => _addJobDataToStream(data),
    );
  }

  static updateJob(Job job) {
    socketWrapper.socket.emitWithAck(
      "updateJob",
      job,
      ack: (data) => _addJobDataToStream(data),
    );
  }

  static createJob(Job job) {
    socketWrapper.socket.emit("createJob", job);
  }

  static removeJob(String jobId) {
    socketWrapper.socket.emit("removeJob", jobId);
  }
}
