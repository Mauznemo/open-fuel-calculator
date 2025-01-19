import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_calculator_flutter/models/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final FocusNode _dropdownFocusNode = FocusNode();
  final _priceController = TextEditingController();

  late List<Vehicle> _vehicles = [];

  Vehicle? _selectedVehicle;

  late String _distanceUnit = "";
  late String _consumptionUnit = "";
  late String _volumeUnit = "";
  late String _currency = "€";
  late double _lastPrice = -1;

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

  void _getData() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("initialized") == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/welcome', (route) => false);
    }

    setState(() {
      _lastPrice = prefs.getDouble('lastPrice') ?? -1;
      _distanceUnit = prefs.getString('distanceUnit') ?? 'km';
      _consumptionUnit = prefs.getString('consumptionUnit') ?? 'L/100km';
      _currency = prefs.getString('currency') ?? '€';

      switch (_consumptionUnit) {
        case "L/100km":
        case "km/L":
          _volumeUnit = "liter";
          break;
        case "mpg (US)":
          _volumeUnit = "us gallon";
          break;
        case "mpg (UK)":
          _volumeUnit = "uk gallon";
          break;
      }
    });

    if (_vehicles.isNotEmpty) {
      _vehicleController.text =
          "${_selectedVehicle?.name} (${_selectedVehicle?.consumption.toStringAsFixed(2)} $_consumptionUnit)"; //Have to manually set the text or else it won't show consumptionUnit
    } else {
      _vehicleController.text = "No vehicles found";
    }

    if (_lastPrice != -1) {
      _priceController.text = _lastPrice.toString();
    }
  }

  void _savePriceData() async {
    if (_priceController.text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(
        'lastPrice', double.parse(_priceController.text.replaceAll(',', '.')));
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
    _distanceController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  String _getCost() {
    if (_vehicleController.text.isEmpty ||
        _distanceController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _vehicles.isEmpty) {
      return "";
    }

    double consumption = _selectedVehicle?.consumption ?? 0;
    double distance =
        double.parse(_distanceController.text.replaceAll(',', '.'));
    double price = double.parse(_priceController.text.replaceAll(',', '.'));

    double distanceInKm =
        _distanceUnit == "miles" ? distance * 1.60934 : distance;

    double consumptionAsLPer100km = _getConsumptionAsLPer100km(consumption);

    double pricePerL = _getPriceAsPerL(price);

    return "${((distanceInKm * consumptionAsLPer100km / 100) * pricePerL).toStringAsFixed(2)}$_currency";
  }

  double _getPriceAsPerL(price) {
    switch (_volumeUnit) {
      case "liter":
        return price;
      case "us gallon":
        return price / 3.78541;
      case "uk gallon":
        return price / 4.54609;
      default:
        return 0;
    }
  }

  double _getConsumptionAsLPer100km(consumption) {
    switch (_consumptionUnit) {
      case "L/100km":
        return consumption;
      case "km/L":
        return 100 / consumption;
      case "mpg (US)":
        return 235.214 / consumption;
      case "mpg (UK)":
        return 282.481 / consumption;
      default:
        return 0;
    }
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
                  _selectedVehicle = v;
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
                controller: _distanceController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Distance ($_distanceUnit)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  _savePriceData();
                  FocusScope.of(context).unfocus();
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')),
                ],
                controller: _priceController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Price ($_currency per $_volumeUnit)',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _getCost(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Your FAB action
            AddVehicleBottomSheet.showBottomSheet(context, _consumptionUnit)
                .then((value) {
              _getVehicles();
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
