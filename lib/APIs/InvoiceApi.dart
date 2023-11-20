import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:rsforms/Models/invoiceModel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class InvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = pw.Document();

    for (var i = 0; i < invoice.services.length; i++) {
      if (invoice.services[i].typeofCharge == "Labour") {
        var temp = invoice.services[i];
        invoice.services.removeAt(i);
        invoice.services.insert(0, temp);
      }
    }
    double totalcost = 0;
    invoice.services.forEach((service) => totalcost = totalcost + service.totalPrice);

    //generating content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Divider(color: PdfColors.redAccent700, thickness: 15),
            pw.SizedBox(
              height: 25,
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 20),
              child: pw.Column(
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      invoice.company.name,
                      style: pw.TextStyle(color: PdfColors.redAccent700, fontSize: 20),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      '${invoice.company.city}, ${invoice.company.address}',
                      style: pw.TextStyle(color: PdfColors.black, fontSize: 12),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      '${invoice.company.postcode}',
                      style: pw.TextStyle(color: PdfColors.black, fontSize: 12),
                    ),
                  ),
                  pw.SizedBox(height: 25),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(left: 5),
                      child: pw.Text(
                        "Invoice",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 25,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      "Submitted on       ${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
                      style: pw.TextStyle(color: PdfColors.black, fontSize: 15, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.SizedBox(
                      child: pw.GridView(
                        crossAxisCount: 3,
                        children: [
                          pw.Text(
                            "Invoice for",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            "Job No",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            "Invoice #",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            invoice.job.subCompany,
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            invoice.job.jobNo,
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          if (invoice.job.invoiceNumber != "Hasn't been set yet")
                            pw.Text(
                              "RS ${invoice.job.invoiceNumber}",
                              style: pw.TextStyle(fontSize: 12),
                            )
                          else
                            pw.Text(
                              "RS ${invoice.company.InvoiceCounter}",
                              style: pw.TextStyle(fontSize: 12),
                            )
                        ],
                      ),
                      height: 70),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(invoice.job.address, style: pw.TextStyle(color: PdfColors.black)),
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(invoice.job.postcode, style: pw.TextStyle(color: PdfColors.black)),
                  ),
                  pw.Divider(color: PdfColors.redAccent700, thickness: 3),
                  pw.Column(
                    children: [
                      pw.SizedBox(height: 20),
                      pw.Row(
                        children: [
                          pw.Text("Description", style: pw.TextStyle(color: PdfColors.redAccent700, fontSize: 15)),
                          pw.Spacer(),
                          pw.Text("Qty", style: pw.TextStyle(color: PdfColors.redAccent700, fontSize: 15)),
                          pw.SizedBox(width: 20),
                          pw.Text("Unit Price", style: pw.TextStyle(color: PdfColors.redAccent700, fontSize: 15)),
                          pw.SizedBox(width: 25),
                          pw.Text("Total Price", style: pw.TextStyle(color: PdfColors.redAccent700, fontSize: 15)),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.ListView.builder(
                        itemCount: invoice.services.length,
                        spacing: 20,
                        itemBuilder: (context, index) {
                          var service = invoice.services[index];
                          return pw.Row(
                            children: [
                              pw.Container(
                                width: 150,
                                child: pw.Text(
                                  service.description,
                                  style: pw.TextStyle(color: PdfColors.black, fontSize: 9),
                                ),
                              ),
                              pw.SizedBox(width: 40),
                              pw.Container(
                                width: 55,
                                child: pw.Text(
                                  service.typeofCharge,
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Container(
                                width: 20,
                                child: pw.Text(
                                  "${service.quantity}",
                                  style: pw.TextStyle(color: PdfColors.black, fontSize: 11),
                                ),
                              ),
                              pw.SizedBox(width: 25),
                              pw.Container(
                                width: 50,
                                child: pw.Text(
                                  "£${service.price.toStringAsFixed(2)}",
                                  style: pw.TextStyle(color: PdfColors.black, fontSize: 11),
                                ),
                              ),
                              pw.SizedBox(width: 50),
                              pw.Container(
                                width: 50,
                                child: pw.Text(
                                  "£${service.totalPrice.toStringAsFixed(2)}",
                                  style: pw.TextStyle(color: PdfColors.black, fontSize: 11),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Divider(color: PdfColors.redAccent700, thickness: 2),
                      ),
                      pw.SizedBox(width: 25),
                      pw.Text(
                        "Subtotal  £${totalcost.toStringAsFixed(2)}",
                        style: pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    height: 100,
                    child: pw.Row(
                      children: [
                        pw.Flexible(
                          flex: 1,
                          child: pw.Column(
                            children: [
                              pw.Align(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text(
                                  "Bank Details: ",
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: PdfColors.redAccent400,
                                  ),
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Bank Name"),
                                  pw.Spacer(),
                                  pw.Text(invoice.company.bankName),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Account Number"),
                                  pw.Spacer(),
                                  pw.Text(invoice.company.accountNumber),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Sort Code"),
                                  pw.Spacer(),
                                  pw.Text(invoice.company.sortCode),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.Flexible(
                          flex: 1,
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              "£${totalcost.toStringAsFixed(2)}",
                              style: pw.TextStyle(
                                  color: PdfColors.redAccent700, fontSize: 18, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]; // Center
        },
      ),
    );

    // saving and returning document
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    var file;
    if (invoice.job.invoiceNumber != "Hasn't been set yet") {
      file = File('${dir.path}/RS${invoice.job.invoiceNumber}_${invoice.job.subCompany}.pdf');
    } else {
      file = File('${dir.path}/RS${invoice.company.InvoiceCounter}_${invoice.job.subCompany}.pdf');
    }

    await file.writeAsBytes(bytes);

    return file;
  }
}
