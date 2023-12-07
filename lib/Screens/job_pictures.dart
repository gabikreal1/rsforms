import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Components/imageCapture.dart';
import 'package:rsforms/Providers/PictureProvider.dart';
import 'package:share_plus/share_plus.dart';

class PicturePage extends StatefulWidget {
  const PicturePage({super.key});

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  Set<String> _selectedImages = Set();
  bool _imageSelectedState = false;

  void selectFirstImage(String imagelink) {
    if (_selectedImages.length == 0) {
      setState(() {
        _imageSelectedState = true;
        _selectedImages.add(imagelink);
      });
    }
  }

  void selectImage(String imagelink) {
    if (_imageSelectedState == false) {
      return;
    }
    if (_selectedImages.contains(imagelink)) {
      if (_selectedImages.length == 1) {
        setState(() {
          _imageSelectedState = false;
          _selectedImages.remove(imagelink);
        });
      } else {
        setState(() {
          _selectedImages.remove(imagelink);
        });
      }
    } else {
      setState(() {
        _selectedImages.add(imagelink);
      });
    }
  }

  void sendImages() async {
    List<XFile> images = [];
    var provider = Provider.of<PictureProvider>(context, listen: false);
    for (var imageLink in _selectedImages) {
      var file = await provider.getImageFromCache(imageLink);
      images.add(file);
    }
    await Share.shareXFiles(
      images,
    );
    setState(() {
      _selectedImages.clear();
      _imageSelectedState = false;
    });
  }

  void deleteImages() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      bottomNavigationBar: Row(
        children: [
          if (_imageSelectedState == true) ...[
            IconButton(
              onPressed: () {
                sendImages();
              },
              icon: Icon(Icons.file_upload_outlined, color: Colors.white),
            ),
            Spacer(),
            Text(
              "Selected: ${_selectedImages.length}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  deleteImages();
                },
                icon: Icon(Icons.delete, color: Colors.white))
          ]
        ],
      ),
      body: SafeArea(
        child: Consumer<PictureProvider>(
          builder: (context, value, child) {
            List<String> imageLinks = value.imageLinkList;
            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                      ),
                      color: Colors.white,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageCapture(),
                          ),
                        );
                        await value.getImageLinkList();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (imageLinks.length != 0)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: imageLinks.length,
                      itemBuilder: (context, index) {
                        String imageLink = imageLinks[index];
                        return GestureDetector(
                          onLongPress: () {
                            selectFirstImage(imageLink);
                            HapticFeedback.heavyImpact();
                          },
                          onTap: () {
                            selectImage(imageLink);
                            HapticFeedback.mediumImpact();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(imageLink),
                                ),
                              ),
                              child: (_selectedImages.contains(imageLink))
                                  ? Container(
                                      color: Colors.blue.withOpacity(0.25),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  : (_imageSelectedState)
                                      ? Container(
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Icon(
                                                Icons.circle_outlined,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()),
                        );
                      },
                    ),
                  )
                else
                  Text(
                    "No images",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
