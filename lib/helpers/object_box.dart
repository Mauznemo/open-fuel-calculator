import 'package:fuel_calculator_flutter/objectbox.g.dart';

import '../models/vehicle.dart';

class ObjectBox {
  static late ObjectBox instance;

  late final Store _store;
  late final Box<Vehicle> _vehiclesBox;

  ObjectBox._init(this._store) {
    _vehiclesBox = Box<Vehicle>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();

    instance = ObjectBox._init(store);
    return instance;
  }

  void addVehicle(Vehicle vehicle) {
    _vehiclesBox.put(vehicle);
  }

  Vehicle? getVehicle(int id) {
    return _vehiclesBox.get(id);
  }

  List<Vehicle> getVehicles() {
    return _vehiclesBox.getAll();
  }

  void deleteVehicle(int id) {
    _vehiclesBox.remove(id);
  }

  void updateVehicle(updatedVehicle) {
    _vehiclesBox.put(updatedVehicle);
  }
}
