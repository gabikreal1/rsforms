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
  final Set<String> _selectedImages = {};
  bool _imageSelectedState = false;

  void selectFirstImage(String imagelink) {
    if (_selectedImages.isEmpty) {
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
    HapticFeedback.mediumImpact();
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
      backgroundColor: const Color(0xff31384d),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            if (_imageSelectedState == true) ...[
              IconButton(
                onPressed: () {
                  sendImages();
                },
                icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
              ),
              const Spacer(),
              Text(
                "Selected ${_selectedImages.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    deleteImages();
                  },
                  icon: const Icon(Icons.delete, color: Colors.white))
            ]
          ],
        ),
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
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                      ),
                      color: Colors.white,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ImageCapture(),
                          ),
                        );
                        await value.getImageLinkList();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (imageLinks.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            },
                            child: CachedNetworkImage(
                              imageUrl: imageLink,
                              placeholder: (context, url) {
                                return Container(height: 10, width: 10, child: CircularProgressIndicator.adaptive());
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                    child: (_selectedImages.contains(imageLink))
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(10)),
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
                                            : Container());
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  const Text(
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
