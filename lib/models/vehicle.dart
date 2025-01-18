import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle {
  int id;
  String name;
  double consumption;
  bool isFavorite;

  Vehicle(
      {this.id = 0,
      this.name = "",
      this.consumption = 0,
      this.isFavorite = false});
}
