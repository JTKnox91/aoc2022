import 'dart:io';

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

  String toString() {
    return 'Sensor ($x,$y), d=$distance';
  }
}

class RowRange {
  final int min;
  final int max;
  
  RowRange(this.min, this.max);

  List<RowRange> split(RowRange intersection) {
    RowRange? lower;
    RowRange? upper;
    if (intersection.min > min && intersection.min <= max) {
      lower = RowRange(min, intersection.min-1);
    }
    if (max < intersection.min) {
      lower = this;
    }
    if (intersection.max >= min && intersection.max < max) {
      upper = RowRange(intersection.max+1, max);
    }
    if (min > intersection.max) {
      lower = this;
    }
    return [
      if (lower != null) lower,
      if (upper != null) upper,
    ];
  }

  static List<RowRange> merge(List<RowRange> ranges) {
    ranges.sort((a, b) => a.min - b.min);
    return ranges.fold([], (mergedRanges, nextRange) {
      if (mergedRanges.isEmpty) {
        mergedRanges.add(nextRange);
      } else {
        final lastRange = mergedRanges.last;
        if (lastRange.max >= nextRange.min) {
          if (lastRange.max < nextRange.max) {
            mergedRanges.removeLast();
            mergedRanges.add(RowRange(lastRange.min, nextRange.max));
          }
        } else {
          mergedRanges.add(nextRange);
        }
      }
      return mergedRanges;
    });
  }

  List<int> toList() {
    return List.generate(max+1-min, (index) => min + index);
  }

  String toString() {
    return 'RowRange: $min-$max';
  }
}

class Row {
  final int y;
  List<RowRange> ranges = [];

  Row(this.y, minX, maxX) {
    ranges.add(RowRange(minX, maxX));
  }

  void removeRangeFor(Iterable<Sensor> sensors) {
    final applicableRanges = <RowRange>[];
    for (final sensor in sensors) {
      if (sensor.y > y) {
        if (sensor.y - sensor.distance <= y) {
          final offset = (y - sensor.y) + sensor.distance;
          applicableRanges.add(RowRange(sensor.x - offset, sensor.x + offset));
        }
      } else if (sensor.y < y) {
        if (sensor.y + sensor.distance >= y) {
          final offset = (sensor.y - y) + sensor.distance;
          applicableRanges.add(RowRange(sensor.x - offset, sensor.x + offset));
        }
      } else {
        applicableRanges.add(RowRange(sensor.x - sensor.distance, sensor.x + sensor.distance));
      }
    }
    final applicableRangesMerged = RowRange.merge(applicableRanges);
    for (final mergedRange in applicableRangesMerged) {
      _reduceRanges(mergedRange);
    }
  }

  void _reduceRanges(RowRange intersection) {
    ranges = ranges.fold([], (newRanges, oldRange) {
      newRanges.addAll(oldRange.split(intersection));
      return newRanges;
    });
  }

  List<int> availableColumns() {
    return ranges.map((range) => range.toList()).fold([], (concattenated, list) {
      concattenated.addAll(list);
      return concattenated;
    });
  }

  String toString() {
    return 'Row $y: ${availableColumns()}';
  }
}


void main() {
  final File inputFile = new File('input.txt');
  final sensors = inputFile.readAsLinesSync().map<Sensor>((line) {
    // Sensor at x=1638847, y=3775370: closest beacon is at x=2498385, y=3565515
    line = line.replaceAll('Sensor at x=', '');
    line = line.replaceAll(': closest beacon is at x=', ':');
    line = line.replaceAll(', y=', ',');
    final sensorX = int.parse(line.split(':')[0].split(',')[0]);
    final sensorY = int.parse(line.split(':')[0].split(',')[1]);
    final beaconX = int.parse(line.split(':')[1].split(',')[0]);
    final beaconY = int.parse(line.split(':')[1].split(',')[1]);

    final beacon = TaxiPoint(beaconX, beaconY);
    return Sensor(TaxiPoint(sensorX, sensorY), beacon);
  });

  int minX = 0;
  int minY = 0;

  // // For Example
  // int maxX = 20;
  // int maxY = 20;

  // For Real
  int maxX = 4000000;
  int maxY = 4000000;

  final rows = List.generate(maxY+1-minY, (index) => Row(minY+index, minX, maxX));
  for (final row in rows) {
    if (row.y % 1000 == 0) {
      print('Row: ${row.y}');
    }
    row.removeRangeFor(sensors);    
  }
  print(rows.where((row) {
    return row.availableColumns().isNotEmpty;
  }));
}
