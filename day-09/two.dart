import 'dart:io';

class Knot {
  int x = 0;
  int y = 0;
  Knot? next;
  final visited = <String>{};

  Knot(this.x, this.y, int followers) {
    if (followers > 0) {
      next = Knot(x, y, followers-1);
    }
    _markCurrentLocationAsVisited();
  }

  Knot get tail {
    if (next == null) {
      return this;
    } else {
      return next!.tail;
    }
  }

  void moveTo(newX, newY) {
    x = newX;
    y = newY;
    _markCurrentLocationAsVisited();
    if (next == null) return;
    final deltaX = x - next!.x;
    final deltaY = y - next!.y;

    // If next is in the immeditate surrounding 9 (including covering) locations,
    // do not move.
    if (deltaX.abs() <= 1 && deltaY.abs() <= 1) return;
    // Otherwise figure out if it should follow to a side, or diagonally.
    
    // If travel on x axis is greater, move to left or right side
    if (deltaX.abs() > deltaY.abs()) {
      next!.moveTo(x - deltaX.sign, y);  
    // If travel on y axis is greater, move to top of bottom side
    } else if (deltaY.abs() > deltaX.abs()) {
      next!.moveTo(x, y - deltaY.sign);  
    // If travel is perfectly diagonal, move to corner.
    } else {
      next!.moveTo(x - deltaX.sign, y - deltaY.sign);
    }
  }

  void moveRight() {
    moveTo(x+1, y);
  }

  void moveLeft() {
    moveTo(x-1, y);
  }

  void moveUp() {
    moveTo(x, y+1);
  }

  void moveDown() {
    moveTo(x, y-1);
  }

  void _markCurrentLocationAsVisited() {
    visited.add('$x,$y');
  }

  int get uniqueLocatationsCount {
    return visited.length;
  }

}

void main() {
  final File inputFile = new File('one.input.txt');
  final head = Knot(0, 0, 9);
  for (final line in inputFile.readAsLinesSync()) {
    final direction = line.split(' ')[0];
    int repetitions = int.parse(line.split(' ')[1]);
    while (repetitions > 0) {
      if (direction == 'R') {
        head.moveRight();
      } else if (direction == 'L') {
        head.moveLeft();
      } else if (direction == 'U') {
        head.moveUp();
      } else if (direction == 'D') {
        head.moveDown();
      } else {
        throw ArgumentError('Unknown Direction: $direction');
      }
      repetitions--;
    }
  }

  print(head.tail.uniqueLocatationsCount);
}
