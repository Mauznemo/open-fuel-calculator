import 'package:flutter/material.dart';
import 'package:fuel_calculator_flutter/helpers/object_box.dart';

import '../models/vehicle.dart';
import 'add_vehicle_bottom_sheet.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({super.key});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  List<Vehicle> _vehicles = ObjectBox.instance.getVehicles();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _vehicles.length,
                itemBuilder: (context, index) {
                  final vehicleData =
                      ObjectBox.instance.getVehicle(_vehicles[index].id);
                  return ListTile(
                    leading: IconButton(
                      icon: vehicleData!.isFavorite
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border),
                      onPressed: () {
                        // Ensure only one vehicle is favorited
                        if (!vehicleData.isFavorite) {
                          for (var v in _vehicles) {
                            if (v.isFavorite) {
                              final unfavorited = Vehicle(
                                  id: v.id,
                                  name: v.name,
                                  isFavorite: false,
                                  consumption: v.consumption);
                              ObjectBox.instance.updateVehicle(unfavorited);
                            }
                          }
                        }

                        final updatedVehicle = Vehicle(
                            id: vehicleData.id,
                            name: vehicleData.name,
                            isFavorite: true,
                            consumption: vehicleData.consumption);
                        ObjectBox.instance.updateVehicle(updatedVehicle);
                        _vehicles = ObjectBox.instance.getVehicles();
                        // Rebuild UI to reflect the change
                        setState(() {});
                      },
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${vehicleData.name} (${vehicleData.id})",
                            style: const TextStyle(fontSize: 20)),
                        Text(
                            "Consumption: ${vehicleData.consumption.toStringAsFixed(2)} L/100km",
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Delete vehicle from Hive box
                        ObjectBox.instance.deleteVehicle(_vehicles[index].id);
                        _vehicles = ObjectBox.instance.getVehicles();
                        // Rebuild UI to reflect the change
                        setState(() {});
                        // Or use a ValueListenableBuilder for reactive updates
                      },
                    ),
                  );
                }),
          ),
          FilledButton.icon(
              onPressed: () async {
                await AddVehicleBottomSheet.showBottomSheet(context);
                _vehicles = ObjectBox.instance.getVehicles();
                setState(() {});
              },
              icon: Icon(Icons.add),
              label: Text("Add Vehicle")),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
