import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/object_box.dart';
import '../models/vehicle.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _currencyController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _consumptionController = TextEditingController();

  String distanceUnits = 'km';
  String consumptionUnits = 'L/100km';
  final List<String> consumptionUnitsOptions = [
    "L/100km",
    "km/L",
    "mpg (US)",
    "mpg (UK)"
  ];

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('distanceUnit', distanceUnits);
    await prefs.setString('consumptionUnit', consumptionUnits);
    await prefs.setString('currency', _currencyController.text);
    await prefs.setBool('initialized', true);
  }

  @override
  void initState() {
    super.initState();
    _currencyController.text = "€";
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _currencyController.dispose();
    _vehicleController.dispose();
    _consumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Welcome to Open Fuel Calculator')),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Set Units:',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Distance Unit:', // Label text
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                        height: 8), // Adds spacing between label and dropdown
                    DropdownButton<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      value: distanceUnits,
                      onChanged: (String? newValue) {
                        distanceUnits = newValue!;
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'km',
                          child: Text('km'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'miles',
                          child: Text('miles'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Consumption Unit:', // Label text
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      value: consumptionUnits,
                      onChanged: (String? newValue) {
                        setState(() {
                          consumptionUnits = newValue!;
                        });
                      },
                      items: consumptionUnitsOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Currency Unit:', // Label text
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: _currencyController,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        //labelText: 'Vehicle Name',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Add first vehicle:',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Name:', // Label text
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: _vehicleController,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        //labelText: 'Vehicle Name',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle consumption ($consumptionUnits):', // Label text
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: _consumptionController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+[,.]?\d*')),
                      ],
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        //labelText: 'Vehicle Name',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              FilledButton.icon(
                  onPressed: () {
                    if (_vehicleController.text.isEmpty ||
                        _consumptionController.text.isEmpty) {
                      return;
                    }
                    ObjectBox.instance.addVehicle(Vehicle(
                        name: _vehicleController.text,
                        consumption: double.parse(
                            _consumptionController.text.replaceAll(',', '.'))));
                    _saveData().then((v) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    });
                  },
                  icon: Icon(Icons.done),
                  label: Text("Done")),
            ],
          ),
        ));
  }
}
