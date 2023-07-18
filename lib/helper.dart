import 'dart:math';

class Helper {
  static num getDeviceDistance(int? rssi) {
    if (rssi == null) {
      return 0;
    }
    var measuredPower = -69;
    var lowStrength = 2;

    double exp = (measuredPower - rssi) / (10 * lowStrength);
    num distance = pow(10, exp);

    return distance;
  }

  static num getPercentage(int? rssi) {
    num distance = getDeviceDistance(rssi);
    num minDistance = 0;
    num maxDistance = 20;
    late num percentage;
    if (distance <= minDistance || distance > maxDistance) {
      percentage = 0;
    } else {
      percentage = (1 - (distance / maxDistance)) * 100;
    }

    return percentage.toInt();
  }
}
