class Calculator {
  //TODO: Use enums instead of strings

  static double getPriceAsPerL(double price, String volumeUnit) {
    switch (volumeUnit) {
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

  static double getConsumptionAsLPer100km(
      double consumption, String consumptionUnit) {
    switch (consumptionUnit) {
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

  static double getVolumeAsLiter(double volume, String volumeUnit) {
    switch (volumeUnit) {
      case "Liters":
        return volume;
      case "US gallons":
        return volume * 3.78541;
      case "UK gallons":
        return volume * 4.54609;
      default:
        return 0;
    }
  }

  static double convertDistanceFromKm(double distance, String distanceUnit) {
    switch (distanceUnit) {
      case "km":
        return distance;
      case "miles":
        return distance * 0.621371;
      default:
        return 0;
    }
  }
}
