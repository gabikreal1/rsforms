import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../Models/invoiceModel.dart';

class pdfViewPage extends StatefulWidget {
  final path;
  Invoice invoice;
  var isReady = false;
  var page = 0;
  pdfViewPage({super.key, required this.path, required this.invoice});

  @override
  State<pdfViewPage> createState() => _pdfViewPageState();
}

class _pdfViewPageState extends State<pdfViewPage> {
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
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: 500,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: PDFView(
                    filePath: widget.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onRender: (_pages) {
                      setState(() {
                        widget.page = _pages!;
                        widget.isReady = true;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Share.shareXFiles(
                    [XFile(widget.path, mimeType: "application/pdf")],
                    text: "Invoice \n Many Thanks, \n ${widget.invoice.company.name}",
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
