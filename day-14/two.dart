import 'dart:io';
import 'dart:math';


void main() {
  final File inputFile = new File('input.txt');
  final List<List<Point<int>>> paths = [];
  num highestY = 0;
  num lowestY = double.negativeInfinity;
  num lowestX = double.infinity;
  num highestX = double.negativeInfinity;
  for (final line in inputFile.readAsLinesSync()) {
    paths.add([]);
    for (final coord in line.split(' -> ')) {
      final coords = coord.split(',');
      final x = int.parse(coords[0]);
      final y = int.parse(coords[1]);
      lowestY = max(lowestY, y); // Bigger number is "lower", counting from top to bottom.
      lowestX = min(lowestX, x);
      highestX = max(highestX, x);
      paths.last.add(Point(x, y));
    }
  }

  // Add the floor
  lowestY += 2;

  // Ensure there's enough horizontal room to stack to the top.
  lowestX -= lowestY;
  highestX += lowestY;

  List<List<bool>> cave = [];
  for (int row = highestY.toInt(); row <= lowestY; row++) {
    cave.add([]);
    for (int col = lowestX.toInt(); col <= highestX; col++) {
      cave.last.add(false);
    }
  }

  bool isInBounds(Point point) {
    final row = point.y as int;
    final col = point.x - lowestX as int;
    if (row < 0 || row >= cave.length || col < 0 || col >= cave.first.length) {
      return false;
    } else {
      return true;
    }
  }

  void plotPoint(Point point) {
    // print('plotPoint, $point');
    if (!isInBounds(point)) {
      throw ArgumentError('Point exceeds cave boundaries');
    }
    final row = point.y as int;
    final col = point.x - lowestX as int;
    cave[row][col] = true;
  }

  bool isOccupied(Point point) {
    if (!isInBounds(point)) {
      throw ArgumentError('Point exceeds cave boundaries');
    }
    final row = point.y as int;
    final col = point.x - lowestX as int;
    // print('isOccupied, $point, ${cave[row][col]}');
    return cave[row][col];
  }

  paths.add([Point(lowestX as int, lowestY as int), Point(highestX as int, lowestY)]);

  for (final path in paths) {
    int pointIndex = 0;
    while (pointIndex < path.length -1) {
      final currentPoint = path[pointIndex];
      final destinationPoint = path[pointIndex+1];
      if (currentPoint.x != destinationPoint.x && currentPoint.y == destinationPoint.y) {
        final y = currentPoint.y;
        if (currentPoint.x < destinationPoint.x) {
          for (int x = currentPoint.x; x < destinationPoint.x; x++ ) {
            plotPoint(Point(x, y));
          }
        } else {
          for (int x = currentPoint.x; x > destinationPoint.x; x-- ) {
            plotPoint(Point(x, y));
          }
        }
      } else if (currentPoint.x == destinationPoint.x && currentPoint.y != destinationPoint.y) {
        final x = currentPoint.x;
        if (currentPoint.y < destinationPoint.y) {
          for (int y = currentPoint.y; y < destinationPoint.y; y++) {
            plotPoint(Point(x, y));
          }
        } else {
          for (int y = currentPoint.y; y > destinationPoint.y; y--) {
            plotPoint(Point(x, y));
          }
        }        
      } else {
        throw ArgumentError('Points are diagonal: $currentPoint -> $destinationPoint');
      }
      pointIndex++;
    }
    // Plot the very last destination point too.
    plotPoint(path[pointIndex]);
  }

  // // Debug function to print out the state of the cave.
  // void printCave() {
  //   for (final row in cave) {
  //     print(row.map((bool occupied) {
  //       if (occupied) {
  //         return 'X';
  //       } else {
  //         return '.';
  //       }
  //     }).join(''));
  //   }
  // }
  // printCave();
  

  int grainsOfSand = 0;
  bool blockingTheOrigin = false;

  while (!blockingTheOrigin) {
    grainsOfSand++;
    int x = 500;
    int y = 0;

    bool atRest = false;
  
    while (!atRest) {
      final below = Point(x, y+1);
      final diagonalLeft = Point(x-1, y+1);
      final diagonalRight = Point(x+1, y+1);

      if (isOccupied(Point(x,y))) {
        blockingTheOrigin = true;
        break;
      }


      if (!isOccupied(below)) {
        y += 1;
        continue;
      }

      if (!isOccupied(diagonalLeft)) {
        y += 1;
        x -= 1;
        continue;
      }

      if (!isOccupied(diagonalRight)) {
        y += 1;
        x += 1;
        continue;
      }

      plotPoint(Point(x,y));
      atRest = true;
      // printCave();
    }
  }

  // The grain can't be placed doesn't count.
  print(grainsOfSand-1);
}
