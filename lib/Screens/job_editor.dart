// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/APIs/InvoiceApi.dart';
import 'package:rsforms/Components/JobEditTile.dart';
import 'package:rsforms/Models/invoiceModel.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import 'package:rsforms/Providers/serviceProvider.dart';
import 'package:rsforms/Screens/service_adder.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:rsforms/Screens/service_editor.dart';
import 'package:share_plus/share_plus.dart';
import '../Models/jobModel.dart';
import '../Providers/jobProvider.dart';

const List<Widget> icons = <Widget>[
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check),
          Text("Completed"),
        ],
      ),
    ),
  ),
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer),
          Text("Awaiting"),
        ],
      ),
    ),
  ),
];

String formatDescription(String description) {
  if (description.length > 18) {
    return "${description.substring(0, 15)}...";
  }
  return description;
}

class JobEditor extends StatelessWidget {
  final String jobId;
  final DateTime day;
  const JobEditor({super.key, required this.jobId, required this.day});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<JobProvider>(
            builder: (context, provider, child) {
              var job = provider.jobs[day]!.where((e) => e.id == jobId).first;

              List<bool> _selectedCompletion = <bool>[job.completed, !job.completed];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => {},
                          icon: Icon(Icons.settings),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    JobEditTile(
                      TileName: "Provider",
                      TileDescription: "${job.subCompany}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "subcompany", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Job No",
                      TileDescription: "${job.jobNo}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "jobno", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Address",
                      TileDescription: "${job.address}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "address", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Postcode",
                      TileDescription: "${job.postcode}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "postcode", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Sub-Contractor",
                      TileDescription: "${job.subContractor}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "subcontractor", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Desciprtion",
                      TileDescription: "${job.description}",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "description", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobTimeEditTile(
                      date: job.earlyTime,
                      TileName: "Early Time",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "timestart", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    JobTimeEditTile(
                      date: job.lateTime,
                      TileName: "Late Time",
                      Update: (value) {
                        jobProvider.updateJob(jobId, "timefinish", value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Completed Toggle Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: Text(
                                "Completed",
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: ToggleButtons(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                children: icons,
                                isSelected: _selectedCompletion,
                                onPressed: (index) {
                                  jobProvider.updateJob(jobId, "completed", index == 0);
                                  _selectedCompletion[0] = !_selectedCompletion[0];
                                  _selectedCompletion[1] = !_selectedCompletion[1];
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    job.completed
                        ? Column(
                            children: [
                              ChangeNotifierProvider<ServiceProvider>(
                                create: (context) {
                                  return ServiceProvider(jobId, provider.company.id);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 2),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                                child: Text(
                                                  "Service/Part",
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Consumer<ServiceProvider>(
                                                builder: (context, value, child) {
                                                  if (value.services.isNotEmpty) {
                                                    return Column(
                                                      children: [
                                                        ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: value.services.length,
                                                          itemBuilder: (context, index) {
                                                            Services service = value.services[index];
                                                            return Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(25.0),
                                                                    border: Border.all(color: Colors.black),
                                                                    color: Colors.white,
                                                                    boxShadow: List.from([
                                                                      BoxShadow(
                                                                          color: Colors.grey, offset: Offset(5, 5))
                                                                    ]),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                                    child: ListTile(
                                                                      onTap: () {
                                                                        showCupertinoModalPopup(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return CupertinoActionSheet(
                                                                              title: Text(
                                                                                  "What actions do you want to take?"),
                                                                              actions: [
                                                                                CupertinoActionSheetAction(
                                                                                  child: Text("Edit"),
                                                                                  onPressed: () async {
                                                                                    await Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) =>
                                                                                            ServiceEditor(
                                                                                          Edit: (typeofCharge,
                                                                                              description,
                                                                                              quantity,
                                                                                              price) {
                                                                                            value.updateService(
                                                                                                service.id!,
                                                                                                description,
                                                                                                price,
                                                                                                quantity,
                                                                                                typeofCharge);
                                                                                          },
                                                                                          type: service.typeofCharge,
                                                                                          quantity: service.quantity,
                                                                                          description:
                                                                                              service.description,
                                                                                          price: service.price,
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                CupertinoActionSheetAction(
                                                                                  child: Text("Delete"),
                                                                                  onPressed: () {
                                                                                    value.deleteService(service.id!);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  isDestructiveAction: true,
                                                                                ),
                                                                              ],
                                                                              cancelButton: CupertinoActionSheetAction(
                                                                                child: Text("Cancel"),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      title: Column(
                                                                        children: [
                                                                          Text(
                                                                            "${service.typeofCharge} ",
                                                                            style: TextStyle(fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                            service.description,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(fontSize: 10),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                " £${service.price} X ",
                                                                                style: TextStyle(fontSize: 10),
                                                                              ),
                                                                              Text(
                                                                                "${service.quantity}",
                                                                                style: TextStyle(fontSize: 10),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Text(
                                                                            " £${service.totalPrice}",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ));
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text("Total Price: £${value.totalPrice}"),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color(0xff31384d),
                                                                ),
                                                                onPressed: () async {
                                                                  await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => ServiceAdder(
                                                                        Add: (typeofCharge, description, quantity,
                                                                            price) {
                                                                          Services service = Services(
                                                                              description: description,
                                                                              price: price,
                                                                              quantity: quantity,
                                                                              typeofCharge: typeofCharge);
                                                                          jobProvider.addService(job.id!, service);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(Icons.add_rounded),
                                                                    Text(
                                                                      "Add new Service/Part",
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            ElevatedButton.icon(
                                                              onPressed: () async {
                                                                if (job.invoiceTime == null) {
                                                                  jobProvider.updateJob(job.id!, "invoicetime",
                                                                      DateTime.now().millisecondsSinceEpoch);
                                                                  await companyProvider.incrementInvoiceCounter();
                                                                }
                                                                var invoice = Invoice(
                                                                    company: companyProvider.company,
                                                                    job: job,
                                                                    services: value.services);
                                                                final pdfInvoice = await InvoiceApi.generate(invoice);

                                                                print(pdfInvoice.path);
                                                                print(await pdfInvoice.length());
                                                                Share.shareXFiles(
                                                                  [XFile(pdfInvoice.path, mimeType: "application/pdf")],
                                                                  text: "pdf",
                                                                );
                                                              },
                                                              label: Text("Generate Invoice"),
                                                              icon: Icon(Icons.document_scanner_rounded),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Color(0xff31384d),
                                                            ),
                                                            onPressed: () async {
                                                              await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ServiceAdder(
                                                                    Add: (typeofCharge, description, quantity, price) {
                                                                      Services service = Services(
                                                                          description: description,
                                                                          price: price,
                                                                          quantity: quantity,
                                                                          typeofCharge: typeofCharge);
                                                                      jobProvider.addService(job.id!, service);
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.add_rounded),
                                                                Text(
                                                                  "Add new Service/Part",
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 10,
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
