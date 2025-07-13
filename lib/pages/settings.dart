import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_calculator_flutter/components/custom_text_input.dart';
import 'package:fuel_calculator_flutter/components/vehicle_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_dropdown_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _currencyController = TextEditingController();
  String distanceUnits = 'km';
  String consumptionUnits = 'L/100km';

  final List<String> consumptionUnitsOptions = [
    "L/100km",
    "km/L",
    "mpg (US)",
    "mpg (UK)"
  ];

  _getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      distanceUnits = prefs.getString('distanceUnit') ?? 'km';
      consumptionUnits = prefs.getString('consumptionUnit') ?? 'L/100km';
      _currencyController.text = prefs.getString('currency') ?? '€';
    });
  }

  _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('distanceUnit', distanceUnits);
    await prefs.setString('consumptionUnit', consumptionUnits);
    await prefs.setString('currency', _currencyController.text);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Settings'),
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Units',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
            const Divider(height: 5, color: Colors.grey),
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
                  CustomDropdownButton<String>(
                    value: distanceUnits,
                    onChanged: (String? newValue) {
                      distanceUnits = newValue!;
                      _saveData();
                      setState(() {});
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
                  const SizedBox(height: 8),
                  CustomDropdownButton<String>(
                    value: consumptionUnits,
                    onChanged: (String? newValue) {
                      setState(() {
                        consumptionUnits = newValue!;
                        _saveData();
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
                    'Currency unit:', // Label text
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextInput(
                    controller: _currencyController,
                    onEditingComplete: () {
                      _saveData();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Vehicles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
            Divider(height: 1, color: Colors.grey),
            SizedBox(height: 20),
            VehicleList(consumptionUnit: consumptionUnits),
            ElevatedButton.icon(
              // Lifts the button up a bit
              onPressed: () async {
                await launchUrl(Uri.parse(
                    "https://github.com/Mauznemo/open-fuel-calculator"));
              },
              icon: const FaIcon(FontAwesomeIcons.github),
              label: const Text("GitHub"),
            ),
            SizedBox(height: 35),
          ],
        ));
  }
}
