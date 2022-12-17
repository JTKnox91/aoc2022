import 'dart:io';
import 'dart:math';

class TaxiPoint {
  static int distanceBetween(TaxiPoint a, TaxiPoint b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  final int x;
  final int y;

  TaxiPoint(this.x, this.y);

  int distanceFrom(TaxiPoint other) {
    return distanceBetween(this, other);
  }

}

class Sensor extends TaxiPoint {
  final int distance;

  Sensor(TaxiPoint sensor, TaxiPoint beacon) : 
      distance = TaxiPoint.distanceBetween(sensor, beacon),
      super(sensor.x, sensor.y);

  isInBeaconDistance(TaxiPoint other) {
    return distanceFrom(other) <= distance;
  }
}


void main() {

  final File inputFile = new File('input.txt');
  final sensors = <String, Sensor>{};
  final beacons = <String, TaxiPoint>{};
  inputFile.readAsLinesSync().forEach((line) {
    // Sensor at x=1638847, y=3775370: closest beacon is at x=2498385, y=3565515
    line = line.replaceAll('Sensor at x=', '');
    line = line.replaceAll(': closest beacon is at x=', ':');
    line = line.replaceAll(', y=', ',');
    final sensorX = int.parse(line.split(':')[0].split(',')[0]);
    final sensorY = int.parse(line.split(':')[0].split(',')[1]);
    final beaconX = int.parse(line.split(':')[1].split(',')[0]);
    final beaconY = int.parse(line.split(':')[1].split(',')[1]);

    final beacon = TaxiPoint(beaconX, beaconY);
    beacons['$beaconX,$beaconY'] = beacon;
    final sensor = Sensor(TaxiPoint(sensorX, sensorY), beacon);
    sensors['$sensorX,$sensorY'] = sensor;
  });

  num leftMostX = double.infinity;
  sensors.forEach((_, sensor) {
    final leftX = sensor.x - sensor.distance;
    leftMostX = min(leftMostX, leftX);
  });
  num rightMostX = double.negativeInfinity;
  sensors.forEach((_, sensor) {
    final rightX = sensor.x + sensor.distance;
    rightMostX = max(rightMostX, rightX);
  });

  int emptySpaces = 0;
  // int y = 10; // For Example
  int y = 2000000; // For real;
  for (int x = leftMostX.toInt(); x <= rightMostX.toInt(); x++) {
    final pointKey = '$x,$y';
    if (sensors.containsKey(pointKey)) continue;
    if (beacons.containsKey(pointKey)) continue;
    
    final point = TaxiPoint(x, y);
    for (final sensor in sensors.values) {
      if (sensor.isInBeaconDistance(point)) {
        emptySpaces++;
        break;
      }
    }
  }

  print(emptySpaces);
}
