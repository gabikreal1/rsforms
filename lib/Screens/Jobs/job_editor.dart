// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/APIs/InvoiceApi.dart';
import 'package:rsforms/Components/JobEditTile.dart';
import 'package:rsforms/Models/invoiceModel.dart';
import 'package:rsforms/Providers/PictureProvider.dart';
import 'package:rsforms/Providers/companyProvider.dart';
import 'package:rsforms/Providers/serviceProvider.dart';
import 'package:rsforms/Screens/Jobs/InvoicePreview.dart';
import 'package:rsforms/Screens/Jobs/job_pictures.dart';
import 'package:rsforms/Screens/Jobs/service_adder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rsforms/Screens/Jobs/service_editor.dart';
import '../../Models/jobModel.dart';
import '../../Providers/jobProvider.dart';

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
    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final pictureProvider = Provider.of<PictureProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<JobProvider>(
            builder: (context, provider, child) {
              if (provider.jobsCalendar[day] == null || provider.jobsCalendar[day]!.containsKey(jobId) == false) {
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
                      ],
                    ),
                    const Text(
                      "Job has been deleted/moved to another day.",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
              Job job = provider.jobsCalendar[day]![jobId]!;
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
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                          ),
                          color: Colors.white,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            pictureProvider.jobId = jobId;
                            pictureProvider.companyId = companyProvider.company.id!;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                });
                            await pictureProvider.getImageLinkList();
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PicturePage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    JobEditTile(
                      TileName: "Provider",
                      TileDescription: job.subCompany,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "subcompany", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Job No",
                      TileDescription: job.jobNo,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "jobno", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Address",
                      TileDescription: job.address,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "address", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Postcode",
                      TileDescription: job.postcode,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "postcode", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobEditTile(
                      TileName: "Sub-Contractor",
                      TileDescription: job.subContractor,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "subcontractor", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiLineJobEditTile(
                      TileName: "Desciprtion",
                      TileDescription: job.description,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "description", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiLineJobEditTile(
                      TileName: "Contact Number",
                      TileDescription: job.contactNumber,
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "contactnumber", value);
                      },
                      Callback: () async {
                        Uri url = Uri(
                          scheme: 'tel',
                          path: job.contactNumber,
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (job.YHS != "None")
                      JobEditTile(
                        TileName: "YHS",
                        TileDescription: job.YHS,
                        Update: (value) {
                          jobProvider.updateJobParameter(jobId, "YHS", value);
                        },
                      ),

                    const SizedBox(
                      height: 10,
                    ),
                    JobTimeEditTile(
                      date: job.earlyTime,
                      TileName: "Early Time",
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "timestart", value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobTimeEditTile(
                      date: job.lateTime,
                      TileName: "Late Time",
                      Update: (value) {
                        jobProvider.updateJobParameter(jobId, "timefinish", value);
                      },
                    ),
                    const SizedBox(
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: Text(
                                "Completed",
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: ToggleButtons(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                children: icons,
                                isSelected: _selectedCompletion,
                                onPressed: (index) {
                                  jobProvider.updateJobParameter(jobId, "completed", index == 0);
                                  _selectedCompletion[0] = !_selectedCompletion[0];
                                  _selectedCompletion[1] = !_selectedCompletion[1];
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    job.completed
                        ? Column(
                            children: [
                              ChangeNotifierProvider<ServiceProvider>(
                                create: (context) {
                                  return ServiceProvider(jobId, provider.company.id!);
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
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                              child: Text(
                                                "Service/Part",
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Consumer<ServiceProvider>(
                                              builder: (context, value, child) {
                                                if (value.services.isNotEmpty) {
                                                  for (var i = 0; i < value.services.length; i++) {
                                                    if (value.services[i].typeofCharge == "Labour") {
                                                      var temp = value.services[i];
                                                      value.services.removeAt(i);
                                                      value.services.insert(0, temp);
                                                    }
                                                  }
                                                  return Column(
                                                    children: [
                                                      ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: value.services.length,
                                                        itemBuilder: (context, index) {
                                                          Services service = value.services[index];
                                                          return Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(25.0),
                                                                  border: Border.all(color: Colors.black),
                                                                  color: Colors.white,
                                                                  boxShadow: List.from([
                                                                    const BoxShadow(
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
                                                                            title: const Text(
                                                                                "What actions do you want to take?"),
                                                                            actions: [
                                                                              CupertinoActionSheetAction(
                                                                                child: const Text("Edit"),
                                                                                onPressed: () async {
                                                                                  await Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) =>
                                                                                          ServiceEditor(
                                                                                        edit: (typeofCharge,
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
                                                                                onPressed: () {
                                                                                  value.deleteService(service.id!);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                isDestructiveAction: true,
                                                                                child: const Text("Delete"),
                                                                              ),
                                                                            ],
                                                                            cancelButton: CupertinoActionSheetAction(
                                                                              child: const Text("Cancel"),
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
                                                                          style: const TextStyle(fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                          service.description,
                                                                          textAlign: TextAlign.center,
                                                                          style: const TextStyle(fontSize: 10),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              " £${service.price.toStringAsFixed(2)} X ",
                                                                              style: const TextStyle(fontSize: 10),
                                                                            ),
                                                                            Text(
                                                                              "${service.quantity}",
                                                                              style: const TextStyle(fontSize: 10),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Text(
                                                                          " £${service.totalPrice.toStringAsFixed(2)}",
                                                                          style: const TextStyle(
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
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text("Total Price: £${value.totalPrice.toStringAsFixed(2)}"),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color(0xff31384d),
                                                              ),
                                                              onPressed: () async {
                                                                await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => ServiceAdder(
                                                                      Add:
                                                                          (typeofCharge, description, quantity, price) {
                                                                        Services service = Services(
                                                                            description: description,
                                                                            price: price,
                                                                            quantity: quantity,
                                                                            typeofCharge: typeofCharge);
                                                                        value.addService(service);
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Row(
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
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text("Invoice No:  ${job.invoiceNumber}"),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          ElevatedButton.icon(
                                                            onPressed: () async {
                                                              showDialog(
                                                                context: context,
                                                                builder: ((context) {
                                                                  return const Center(
                                                                    child: SizedBox(
                                                                        height: 40,
                                                                        width: 40,
                                                                        child: CircularProgressIndicator.adaptive()),
                                                                  );
                                                                }),
                                                              );
                                                              if (job.invoiceNumber == "Hasn't been set yet") {
                                                                //
                                                                await companyProvider.incrementInvoiceCounter();
                                                                job.invoiceTime = DateTime.now();
                                                                job.invoiceNumber =
                                                                    companyProvider.company.InvoiceCounter.toString();
                                                                job.price = value.totalPrice;
                                                                await jobProvider.updateJob(job);
                                                              }

                                                              var invoice = Invoice(
                                                                  company: companyProvider.company,
                                                                  job: job,
                                                                  services: value.services);
                                                              final pdfInvoice = await InvoiceApi.generate(invoice);
                                                              Navigator.pop(context);

                                                              // ignore: use_build_context_synchronously
                                                              await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => PDFViewPage(
                                                                    path: pdfInvoice.path,
                                                                    invoice: invoice,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            label: const Text("Generate Invoice"),
                                                            icon: const Icon(Icons.document_scanner_rounded),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
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
                                                            backgroundColor: const Color(0xff31384d),
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
                                                                    value.addService(service);
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Row(
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
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(
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