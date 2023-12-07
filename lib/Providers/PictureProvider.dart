import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../Models/jobModel.dart';

class PictureProvider with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: "gs://rsforms-6e943.appspot.com");
  final DefaultCacheManager _defaultCacheManager = DefaultCacheManager();

  List<String> _imageLinkList = [];
  StreamSubscription? _firebaseSubscription;

  List<String> get imageLinkList => _imageLinkList;

  late String _companyId;
  late String _jobId;

  set jobId(String value) {
    _jobId = value;
  }

  set companyId(String value) {
    _companyId = value;
  }

  List<String> get imageList => _imageLinkList;
  PictureProvider() {}
  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }

  UploadTask uploadImage(String Filepath, XFile file) {
    return _storage.ref().child(Filepath).putFile(File(file.path));
  }

  Future<String> addImage() async {
    String imageId = "error";
    await FirebaseFirestore.instance
        .collection('comapnies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection('images')
        .add({"jobid": _jobId}).then((value) {
      imageId = value.id;
    });
    return imageId;
  }

  Future<void> getImageLinkList() async {
    List<String> imageIds = [];
    _firebaseSubscription = await FirebaseFirestore.instance
        .collection('comapnies')
        .doc(_companyId)
        .collection('jobs')
        .doc(_jobId)
        .collection('images')
        .get()
        .then((values) async {
      _imageLinkList.clear();

      for (var image in values.docs) {
        imageIds.add(image.id);
      }
      for (var imageId in imageIds) {
        var imageUrl = await cacheImage('images/${imageId}.jpg');
        _imageLinkList.add(imageUrl);
      }
      notifyListeners();
    });
  }

  Future<String> cacheImage(String imagePath) async {
    final Reference ref = _storage.ref().child(imagePath);
    final imageUrl = await ref.getDownloadURL();

    if ((await _defaultCacheManager.getFileFromCache(imageUrl))?.file == null) {
      final imageBytes = await ref.getData(10000000);
      await _defaultCacheManager.putFile(imageUrl, imageBytes!, fileExtension: "jpg");
    }
    return imageUrl;
  }

  Future<XFile> getImageFromCache(String imageUrl) async {
    FileInfo? res = await _defaultCacheManager.getFileFromCache(imageUrl);

    return XFile(res!.file.path);
  }
}
