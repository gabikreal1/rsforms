import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Models/jobModel.dart';
import 'package:rsforms/Providers/jobProvider.dart';

class JobAdder extends StatefulWidget {
  DateTime date;
  JobAdder({super.key, required this.date});

  @override
  State<JobAdder> createState() => _JobAdderState();
}

class _JobAdderState extends State<JobAdder> {
  int curstep = 0;
  int maxStep = 0;
  TextEditingController _providerController = TextEditingController();
  TextEditingController _jobNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postcodeController = TextEditingController();
  TextEditingController _subContractorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime earlyTime = DateTime.now();
  DateTime lateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    earlyTime = widget.date;
    lateTime = widget.date;
    _jobNoController.text = "Sub/";
  }

  StepState checkStepState(index) {
    if (index == curstep) {
      return StepState.editing;
    } else if (index > curstep) {
      return StepState.indexed;
    }
    return StepState.complete;
  }

  // Add not Null checks before Steps.on continue
  // modify the buttons.
  @override
  Widget build(BuildContext context) {
    var jobProvider = Provider.of<JobProvider>(context, listen: false);
    List<Step> getSteps() => <Step>[
          Step(
              title: Text("Provider"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Provider",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _providerController,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 0,
              state: checkStepState(0)),
          Step(
              title: Text("Job No"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Job No",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _jobNoController,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 1,
              state: checkStepState(1)),
          Step(
              title: Text("Address"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 2,
              state: checkStepState(2)),
          Step(
              title: Text("Postcode"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Postcode",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _postcodeController,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 3,
              state: checkStepState(3)),
          Step(
              title: Text("Sub contractor"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Sub Contractor",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _subContractorController,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 4,
              state: checkStepState(4)),
          Step(
              title: Text("Description"),
              content: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _descriptionController,
                  maxLines: null,
                ),
              ),
              isActive: curstep >= 5,
              state: checkStepState(5)),
          Step(
              title: Text("Early Time"),
              content: SizedBox(
                height: 120,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white,
                  initialDateTime: earlyTime,
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  onDateTimeChanged: (DateTime newTime) {
                    earlyTime = newTime;
                  },
                ),
              ),
              isActive: curstep >= 6,
              state: checkStepState(6)),
          Step(
              title: Text("Late Time"),
              content: SizedBox(
                height: 120,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white,
                  initialDateTime: earlyTime,
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  onDateTimeChanged: (DateTime newTime) {
                    lateTime = newTime;
                  },
                ),
              ),
              isActive: curstep >= 7,
              state: checkStepState(7)),
        ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Stepper(
                  type: StepperType.vertical,
                  physics: ClampingScrollPhysics(),
                  steps: getSteps(),
                  currentStep: curstep,
                  onStepTapped: (value) {
                    if (value <= maxStep) {
                      setState(() {
                        curstep = value;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (curstep > 0) {
                      setState(() {
                        curstep -= 1;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  onStepContinue: () {
                    if (curstep < getSteps().length - 1) {
                      setState(() {
                        if (curstep == maxStep) {
                          maxStep += 1;
                        }
                        curstep += 1;
                      });
                    } else {
                      Job job = Job(
                          lateTime: lateTime,
                          completed: false,
                          subCompany: _providerController.text.trim(),
                          jobNo: _jobNoController.text.trim(),
                          invoiceNumber: "Hasn't been set yet",
                          description: _descriptionController.text.trim(),
                          earlyTime: earlyTime,
                          address: _addressController.text.trim(),
                          postcode: _postcodeController.text.trim(),
                          subContractor: _subContractorController.text.trim());
                      jobProvider.addJob(job);

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
