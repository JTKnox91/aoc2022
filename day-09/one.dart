import 'dart:io';

class Head {
  int x = 0;
  int y = 0;
  final Tail tail;

  Head(): tail = Tail(0, 0);

  void moveRight() {
    x++;
    if (tail.x < x-1) {
      tail.followAt(x-1, y);
    }
  }

  void moveLeft() {
    x--;
    if (tail.x > x+1) {
      tail.followAt(x+1, y);
    }
  }

  void moveUp() {
    y++;
    if (tail.y < y-1) {
      tail.followAt(x, y-1);
    }
  }

  void moveDown() {
    y--;
    if (tail.y > y+1) {
      tail.followAt(x, y+1);
    }
  }

}

class Tail {
  int x;
  int y;
  final visited = <String>{};

  Tail(this.x, this.y) {
    _markCurrentLocationAsVisited();
  }

  void _markCurrentLocationAsVisited() {
    visited.add('$x,$y');
  }

  void followAt(newX, newY) {
    x = newX;
    y = newY;
    _markCurrentLocationAsVisited();
  }

  int get uniqueLocatationsCount {
    return visited.length;
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  final head = Head();
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
