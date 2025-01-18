import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/object_box.dart';
import '../models/vehicle.dart';

class AddVehicleBottomSheet extends StatefulWidget {
  const AddVehicleBottomSheet({super.key});

  static Future<void> showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AddVehicleBottomSheet();
        });
  }

  @override
  State<AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<AddVehicleBottomSheet> {
  final _vehicleController = TextEditingController();
  final _consumptionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _vehicleController.dispose();
    _consumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 200),
            child: Divider(thickness: 4),
          ),
          const Text(
            'Add Vehicle',
            style: TextStyle(fontSize: 24),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _vehicleController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Vehicle Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              controller: _consumptionController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Consumption (l/100km)',
              ),
            ),
          ),
          FilledButton.icon(
              onPressed: () {
                ObjectBox.instance.addVehicle(Vehicle(
                    name: _vehicleController.text,
                    consumption: double.parse(_consumptionController.text)));
                _vehicleController.clear();
                _consumptionController.clear();
                Navigator.pop(context);
                //_vehicles = ObjectBox.instance.getVehicles();
                setState(() {});
              },
              icon: Icon(Icons.add),
              label: Text("Add")),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
