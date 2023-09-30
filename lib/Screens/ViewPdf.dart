import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../Models/invoiceModel.dart';

class pdfViewPage extends StatelessWidget {
  final path;
  Invoice invoice;
  pdfViewPage({super.key, required this.path, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: PDFView(
                    filePath: path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Share.shareXFiles(
                    [XFile(path, mimeType: "application/pdf")],
                    text: "Invoice \n Many Thanks, \n ${invoice.company.name}",
                  );
                },
                icon: Icon(Icons.send),
                label: Text("Share"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
