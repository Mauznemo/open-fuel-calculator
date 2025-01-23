import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_calculator_flutter/services/calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/drawer.dart';
import '../helpers/object_box.dart';
import '../models/vehicle.dart';

class RangePage extends StatefulWidget {
  const RangePage({super.key});

  @override
  State<RangePage> createState() => _RangePageState();
}

class _RangePageState extends State<RangePage> {
  final _volumeController = TextEditingController();
  final _vehicleController = TextEditingController();
  final FocusNode _dropdownFocusNode = FocusNode();

  late List<Vehicle> _vehicles = [];

  Vehicle? _selectedVehicle;

  late String _distanceUnit = "";
  late String _consumptionUnit = "";
  late String _volumeUnit = "";

  void _getData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _distanceUnit = prefs.getString('distanceUnit') ?? 'km';
      _consumptionUnit = prefs.getString('consumptionUnit') ?? 'L/100km';

      switch (_consumptionUnit) {
        case "L/100km":
        case "km/L":
          _volumeUnit = "Liters";
          break;
        case "mpg (US)":
          _volumeUnit = "US gallons";
          break;
        case "mpg (UK)":
          _volumeUnit = "UK gallons";
          break;
      }
    });

    if (_vehicles.isNotEmpty) {
      _vehicleController.text =
          "${_selectedVehicle?.name} (${_selectedVehicle?.consumption.toStringAsFixed(2)} $_consumptionUnit)"; //Have to manually set the text or else it won't show consumptionUnit
    } else {
      _vehicleController.text = "No vehicles found";
    }
  }

  void _getVehicles() {
    bool wasEmpty = _vehicles.isEmpty;
    _vehicles = ObjectBox.instance.getVehicles()
      ..sort((a, b) {
        if (a.isFavorite) return -1;
        if (b.isFavorite) return 1;
        return 0;
      });

    if (wasEmpty && _vehicles.isNotEmpty) {
      _selectedVehicle = _vehicles.first;
    }

    setState(() {});
  }

  String _getRange() {
    double consumptionAsLPer100km = Calculator.getConsumptionAsLPer100km(
        _selectedVehicle!.consumption, _consumptionUnit);
    double volume = double.tryParse(_volumeController.text) ?? 0;
    double volumeAsLiter = Calculator.getVolumeAsLiter(volume, _volumeUnit);
    double rangeKm =
        volumeAsLiter / consumptionAsLPer100km * 100; //km per liter
    double range = Calculator.convertDistanceFromKm(rangeKm, _distanceUnit);
    return range == 0 ? "" : "${range.toStringAsFixed(2)} $_distanceUnit";
  }

  @override
  void initState() {
    super.initState();
    _getVehicles();
    _dropdownFocusNode.addListener(() {
      if (_dropdownFocusNode.hasFocus) {
        _vehicleController.clear(); // Clear the controller when focused
      }
    });

    _selectedVehicle = _vehicles.isEmpty ? null : _vehicles.first;
    _getData();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _dropdownFocusNode.dispose();
    _volumeController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Range Calculator'),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then((value) {
                _vehicles = ObjectBox.instance.getVehicles();
                _getVehicles();
                _getData();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownMenu<Vehicle>(
              initialSelection: _vehicles.isEmpty ? null : _vehicles.first,
              width: MediaQuery.of(context).size.width,
              hintText: "Select Vehicle",
              requestFocusOnTap: true,
              controller: _vehicleController,
              focusNode: _dropdownFocusNode,
              enableFilter: true,
              label: const Text('Select Vehicle'),
              onSelected: (Vehicle? v) {
                if (v == null) {
                  return;
                }
                _selectedVehicle = v;
                _dropdownFocusNode.unfocus();
                setState(() {});
              },
              dropdownMenuEntries:
                  _vehicles.map<DropdownMenuEntry<Vehicle>>((Vehicle v) {
                return DropdownMenuEntry<Vehicle>(
                  value: v,
                  label:
                      "${v.name} (${v.consumption.toStringAsFixed(2)} $_consumptionUnit)",
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
              controller: _volumeController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: _volumeUnit,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _getRange(),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
