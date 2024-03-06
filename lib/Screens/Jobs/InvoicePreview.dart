import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../Models/invoiceModel.dart';

class PDFViewPage extends StatefulWidget {
  final path;
  Invoice invoice;
  var isReady = false;
  var page = 0;
  PDFViewPage({super.key, required this.path, required this.invoice});

  @override
  State<PDFViewPage> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  var currentpage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color(0xff31384d),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "${currentpage}/${widget.page}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 30,
        backgroundColor: const Color(0xff31384d),
        title: Text(
          "${widget.invoice.job.invoiceNumber} Preview",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Share.shareXFiles(
                [XFile(widget.path, mimeType: "application/pdf")],
                text: "Many Thanks, \n ${widget.invoice.company.name}",
                subject: "Invoice",
              );
            },
            icon: const Icon(
              Icons.file_upload_outlined,
              color: Colors.white,
            ),
            iconSize: 20,
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 16,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xff31384d),
      body: SafeArea(
        child: PDFView(
          filePath: widget.path,
          enableSwipe: true,
          onPageChanged: (page, total) {
            setState(() {
              currentpage = (page ?? 0) + 1;
            });
          },
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          pageSnap: false,
          onRender: (_pages) {
            setState(() {
              widget.page = _pages!;
              widget.isReady = true;
            });
          },
        ),
      ),
    );
  }
}
