import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/ImageUploader.dart';

import '../Providers/PictureProvider.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  List<XFile?>? _imageFile;

  Future<void> _pickImages() async {
    List<XFile?> selected = await ImagePicker().pickMultiImage();
    if (selected.isEmpty) {
      return;
    }
    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_imageFile == null) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(onPressed: () => _pickImages(), child: const Text("Pick  Images"))
                  ] else ...[
                    Image.file(File(_imageFile!.first!.path)),
                    ElevatedButton(onPressed: () => _pickImages(), child: const Text("Repick  Images")),
                    ImageUploader(Images: _imageFile!)
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
