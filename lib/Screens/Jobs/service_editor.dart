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

class ServiceEditor extends StatefulWidget {
  List<bool> _selectedCompletion = <bool>[true, false];
  String type;
  String description;
  int quantity;
  double price;
  Function(
    String type,
    String description,
    int quantity,
    double price,
  ) edit;
  ServiceEditor(
      {super.key,
      required this.edit,
      required this.type,
      required this.description,
      required this.quantity,
      required this.price});

  @override
  State<ServiceEditor> createState() => _ServiceEditorState();
}

class _ServiceEditorState extends State<ServiceEditor> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  int currentStep = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptionController.text = widget.description;
    _quantityController.text = "${widget.quantity}";
    _priceController.text = "${widget.price}";
    setState(() {
      if (widget.type != "Labour") {
        widget._selectedCompletion = <bool>[false, true];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => [
          Step(
            title: widget._selectedCompletion[0] ? const Text("Labour") : const Text("Parts"),
            content: Center(
              child: ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                isSelected: widget._selectedCompletion,
                onPressed: (index) {
                  setState(() {
                    widget._selectedCompletion[0] = !widget._selectedCompletion[0];
                    widget._selectedCompletion[1] = !widget._selectedCompletion[1];
                  });
                },
                children: icons,
              ),
            ),
          ),
          Step(
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
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                      ),
                      color: Colors.black,
                    ),
                  ],
                ),
                Stepper(
                  steps: getSteps(),
                  currentStep: currentStep,
                  onStepContinue: () {
                    if (currentStep < getSteps().length - 1) {
                      setState(() {
                        currentStep += 1;
                      });
                    } else {
                      var typeofcharge = widget._selectedCompletion[0] ? "Labour" : "Parts";

                      widget.edit(
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
