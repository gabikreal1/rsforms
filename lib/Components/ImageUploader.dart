import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Providers/PictureProvider.dart';

class ImageUploader extends StatefulWidget {
  final List<XFile?> Images;
  const ImageUploader({super.key, required this.Images});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  UploadTask? _uploadTask;
  int _counter = 0;
  void startUpload() async {
    for (var image in widget.Images) {
      String imageId = await Provider.of<PictureProvider>(context, listen: false).addImage();
      String filePath = 'images/${imageId}.jpg';
      setState(() {
        _uploadTask = Provider.of<PictureProvider>(context, listen: false).uploadImage(filePath, image!);
      });
      await _uploadTask;

      _counter += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder(
          stream: _uploadTask!.snapshotEvents,
          builder: (context, snapshot) {
            var event = snapshot.data;
            double progressPercent = event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Column(
              children: [
                if (_counter == widget.Images.length) ...[
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Exit"))
                ] else ...[
                  LinearProgressIndicator(
                    value: progressPercent,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(0)}% ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${_counter}/${widget.Images.length}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ]
              ],
            );
          });
    } else {
      return ElevatedButton.icon(onPressed: startUpload, icon: Icon(Icons.cloud_upload), label: Text("Upload"));
    }
  }
}
