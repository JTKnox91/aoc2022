import 'dart:io';

class Node {
  static elevationConverstion(String char) {}

  Node? up;
  Node? down;
  Node? left;
  Node? right;

  final int elevation;
  final bool isStart;
  final bool isEnd;
  int? distanceFromEnd;
  final String char;

  Node(this.char)
    : elevation = (char == 'S') ? 'a'.codeUnitAt(0) : (char == 'E') ? 'z'.codeUnitAt(0) : char.codeUnitAt(0),
      isStart = char == 'S' || char == 'a',
      isEnd = char == 'E';

  canTravelFrom(Node from) {
    return from.elevation >= elevation - 1;
  }

  Iterable<Node> get pathableNodes {
    return [up, down, left, right].where((node) => node != null).cast<Node>();
  }

  void markPathableNodes(int distance) {
    distanceFromEnd = distance;

    if (isStart) return;

    final unmarkedNodes = <Node>[];
    for (final node in pathableNodes) {
      if (node.distanceFromEnd == null || node.distanceFromEnd! > distance+1) {
        unmarkedNodes.add(node);
      }
    }
    for (final node in unmarkedNodes) {
      node.markPathableNodes(distance + 1);
    }
  }

  String toString() {
    return '$char[$elevation]';
  }
}


void main() {
  final File inputFile = new File('one.input.txt');
  final List<List<Node>> elevationMap = [];
  for (final line in inputFile.readAsLinesSync()) {
    elevationMap.add([]);
    for (final char in line.split('')) {
      elevationMap.last.add(Node(char));
    }
  }

  // Can guarantee these will be assigned by end of the forloops.
  Node? endNode;
  List<Node> startNodes = [];;

  for (int row = 0; row < elevationMap.length; row++) {
    for (int col = 0; col < elevationMap.first.length; col++) {
      final node = elevationMap[row][col];
      if (node.isEnd) endNode = node;
      if (node.isStart) startNodes.add(node);
      if (col-1 > -1) {
        final left = elevationMap[row][col-1];
        if (node.canTravelFrom(left)) {
          node.left = left;
        }
      }
      if (col+1 < elevationMap.first.length) {
        final right = elevationMap[row][col+1];
        if (node.canTravelFrom(right)) {
          node.right = right;
        }
      }
      if (row-1 > -1) {
        final up = elevationMap[row-1][col];
        if (node.canTravelFrom(up)) {
          node.up = up;
        }
      }
      if (row+1 < elevationMap.length) {
        final down = elevationMap[row+1][col];
        if (node.canTravelFrom(down)) {
          node.down = down;
        }
      }
    }
  }

  endNode!.markPathableNodes(0);
  print(startNodes.reduce((lowestNode, node) {
    if ((node.distanceFromEnd ?? double.infinity) < (lowestNode.distanceFromEnd ?? double.infinity)) {
      return node;
    } else {
      return lowestNode;
    }
  }).distanceFromEnd);
}
