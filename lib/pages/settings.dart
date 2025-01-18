import 'package:flutter/material.dart';
import 'package:fuel_calculator_flutter/components/vehicle_list.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String distanceUnits = 'km';
  String consumptionUnits = 'L/100km';

  final List<String> consumptionUnitsOptions = [
    "L/100km",
    "L/km",
    "mpg (US)",
    "mpg (UK)"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Units', style: Theme.of(context).textTheme.titleLarge),
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
                  DropdownButton<String>(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(10),
                    value: distanceUnits,
                    onChanged: (String? newValue) {
                      setState(() {
                        distanceUnits = newValue!;
                      });
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
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Vehicles',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Divider(height: 1, color: Colors.grey),
            VehicleList(),
          ],
        ));
  }
}
