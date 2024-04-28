import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Repositories/custom_socket.dart';
import '../Services/config_service.dart';

class JobRepository {
  /*
    Same as CompanyRepository, but for jobs
  */

  static late CustomSocketWrapper socketWrapper;

  /// As we will usually fetch multiple jobs, the stream consists of List<Job>
  static final StreamController<List<Job?>?> _jobStreamSocket = StreamController<List<Job?>?>.broadcast();

  static Stream<List<Job?>?> get jobStream => _jobStreamSocket.stream;

  ///Adds data to a stream
  static void _addJobDataToStream(dynamic data) {
    List<Job?> response = [];
    for (var doc in data) {
      response.add(Job.fromJson(doc));
    }
    _jobStreamSocket.add(response);
  }

  static getAllJobs() async {
    socketWrapper.socket.emitWithAck(
      "findAllJobs",
      "",
      ack: (data) => _addJobDataToStream(data),
    );
  }

  static getLastUpdatedJobs(int lastUpdated) async {
    socketWrapper.socket.emitWithAck(
      "lastUpdatedJobs",
      lastUpdated,
      ack: (data) => _addJobDataToStream(data),
    );
  }

  /// Fetches initial data and adds it to the stream and then listens to updates
  static listenToJobUpdates() async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    socketWrapper = CustomSocketWrapper("${ConfigService.defaultApiPath}/jobs", token!);

    socketWrapper.socket.on(
      "createdJob",
      (data) => _addJobDataToStream(data),
    );

    socketWrapper.socket.on(
      "updatedJob",
      (data) => _addJobDataToStream(data),
    );
    socketWrapper.socket.on(
      "removedJob",
      (data) => _addJobDataToStream(data),
    );
  }

  static updateJob(Job job) {
    socketWrapper.socket.emitWithAck(
      "updateJob",
      job.toMap(),
      ack: (data) => _addJobDataToStream(data),
    );
  }

  static createJob(Job job) {
    socketWrapper.socket.emit("createJob", job.toMap());
  }

  static removeJob(Job job) {
    job.removed = true;
    socketWrapper.socket.emit("removeJob", job.id!);
  }
}
