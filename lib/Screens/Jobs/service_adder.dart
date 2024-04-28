import 'package:flutter/material.dart';

const List<Widget> icons = <Widget>[
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_repair_service_sharp),
          SizedBox(
            width: 10,
          ),
          Text("Labour"),
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
          Icon(Icons.miscellaneous_services),
          SizedBox(
            width: 10,
          ),
          Text("Parts"),
        ],
      ),
    ),
  ),
];

class ServiceAdder extends StatefulWidget {
  final List<bool> _selectedCompletion = <bool>[true, false];
  Function(
    String type,
    String description,
    int quantity,
    double price,
  ) Add;
  ServiceAdder({super.key, required this.Add});

  @override
  State<ServiceAdder> createState() => _ServiceAdderState();
}

// add step states and active as did in job_adder
// not null checker.
//make custom onContinue() and onCancel() buttons.
class _ServiceAdderState extends State<ServiceAdder> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int currentStep = 0;

  StepState checkStepState(index) {
    if (index == currentStep) {
      return StepState.editing;
    } else if (index < currentStep) {
      return StepState.complete;
    }
    return StepState.indexed;
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => [
          Step(
            isActive: currentStep >= 0,
            state: checkStepState(0),
            title: widget._selectedCompletion[0] ? const Text("Labour") : const Text("Parts"),
            content: Center(
              child: ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                children: icons,
                isSelected: widget._selectedCompletion,
                onPressed: (index) {
                  setState(() {
                    widget._selectedCompletion[0] = !widget._selectedCompletion[0];
                    widget._selectedCompletion[1] = !widget._selectedCompletion[1];
                  });
                },
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            state: checkStepState(1),
            title: const Text("Description"),
            content: Center(
              child: TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "Description"),
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 2,
            state: checkStepState(2),
            title: const Text("Quantity"),
            content: Center(
              child: TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "Quantity"),
                controller: _quantityController,
                keyboardType: TextInputType.number,
                maxLines: null,
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 3,
            state: checkStepState(3),
            title: const Text("Price"),
            content: Center(
              child: TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "Price"),
                controller: _priceController,
                maxLines: null,
              ),
            ),
          ),
        ];

    return Scaffold(
      // backgroundColor: Color(0xff31384d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                    ),
                    const Spacer(),
                  ],
                ),
                Stepper(
                  steps: getSteps(),
                  currentStep: currentStep,
                  onStepTapped: (value) {
                    if (value < currentStep) {
                      setState(() {
                        currentStep = value;
                      });
                    }
                  },
                  onStepContinue: () {
                    if (currentStep < getSteps().length - 1) {
                      setState(() {
                        currentStep += 1;
                      });
                    } else {
                      var typeofcharge = widget._selectedCompletion[0] ? "Labour" : "Parts";

                      widget.Add(
                        typeofcharge,
                        _descriptionController.text,
                        int.parse(_quantityController.text.trim()),
                        double.parse(_priceController.text.trim()),
                      );
                      Navigator.pop(context);
                    }
                  },
                  onStepCancel: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep -= 1;
                      });
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
