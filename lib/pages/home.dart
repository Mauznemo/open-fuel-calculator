import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_calculator_flutter/models/vehicle.dart';

import '../components/add_vehicle_bottom_sheet.dart';
import '../helpers/object_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _distanceController = TextEditingController();
  final _vehicleController = TextEditingController();
  FocusNode _dropdownFocusNode = FocusNode();
  final _priceController = TextEditingController();

  List<Vehicle> _vehicles = ObjectBox.instance.getVehicles()
    ..sort((a, b) {
      if (a.isFavorite) return -1;
      if (b.isFavorite) return 1;
      return 0;
    });

  Vehicle? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _dropdownFocusNode.addListener(() {
      if (_dropdownFocusNode.hasFocus) {
        _vehicleController.clear(); // Clear the controller when focused
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _dropdownFocusNode.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  String _getCost() {
    if (_vehicleController.text.isEmpty ||
        _distanceController.text.isEmpty ||
        _priceController.text.isEmpty) return "Please fill all fields";

    return "${(_selectedVehicle!.consumption * double.parse(_distanceController.text.replaceAll(',', '.')) * double.parse(_priceController.text.replaceAll(',', '.'))).toStringAsFixed(2)}€";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fuel Calculator'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownMenu<Vehicle>(
                initialSelection: _vehicles.first,
                width: MediaQuery.of(context).size.width,
                hintText: "Select Vehicle",
                requestFocusOnTap: true,
                controller: _vehicleController,
                focusNode: _dropdownFocusNode,
                enableFilter: true,
                label: const Text('Select Vehicle'),
                onSelected: (Vehicle? v) {
                  _selectedVehicle = v;
                  setState(() {});
                },
                dropdownMenuEntries:
                    _vehicles.map<DropdownMenuEntry<Vehicle>>((Vehicle v) {
                  return DropdownMenuEntry<Vehicle>(
                    value: v,
                    label:
                        "${v.name} (${v.consumption.toStringAsFixed(2)} L/10km)",
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')),
                ],
                controller: _distanceController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Distance (km)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')),
                ],
                controller: _priceController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Price (per liter)',
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_getCost(),
                    style: Theme.of(context).textTheme.titleLarge))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Your FAB action
            AddVehicleBottomSheet.showBottomSheet(context);
          },
          child: const Icon(Icons.add),
        ));
  }
}
