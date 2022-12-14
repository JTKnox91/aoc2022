import 'dart:io';

typedef Tree? Next(Tree current);

class Tree {
  int height;

  Tree? north = null;
  Tree? east = null;
  Tree? south = null;
  Tree? west = null;

  Tree(this.height);

  int _viewDistance(Tree? current, Next next) {
    int distance = 0;
    while (current != null) {
      if (current.height < height) {
        distance++;
        current = next(current);
      } else {
        distance++;
        break;
      }
    }
    return distance;
  }

  int viewDistanceNorth() {
    return _viewDistance(north, (current) => current.north);
  }

  int viewDistanceEast() {
    return _viewDistance(east, (current) => current.east);
  }

  int viewDistanceSouth() {
    return _viewDistance(south, (current) => current.south);
  }

  int viewDistanceWest() {
    return _viewDistance(west, (current) => current.west);
  }

  int totalScenicScore() {
    return viewDistanceNorth() 
        * viewDistanceEast()
        * viewDistanceSouth()
        * viewDistanceWest();
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  final List<List<Tree>> forest = [];
  for (final line in inputFile.readAsLinesSync()) {
    forest.add(line.split('').map((String digit) => Tree(int.parse(digit))).toList());
  }

  // Rows west to east
  for (int row = 0; row < forest.length; row++) {
    Tree westTree = forest[row][0];
    for (int col = 1; col < forest.first.length; col++) {
      westTree.east = forest[row][col];
      westTree = westTree.east!;
    }
  }

  // Rows east to west
  for (int row = 0; row < forest.length; row++) {
    Tree eastTree = forest[row][forest.first.length-1];
    for (int col = forest.first.length - 1; col >= 0; col--) {
      eastTree.west = forest[row][col];
      eastTree = eastTree.west!;
    }
  }

  // Cols north to south
  for (int col = 0; col < forest.first.length; col++) {
    Tree northTree = forest[0][col];
    for (int row = 1; row < forest.length; row++) {
      northTree.south = forest[row][col];
      northTree = northTree.south!;
    }
  }

  // Cols south to north
  for (int col = 0; col < forest.first.length; col++) {
    Tree southTree = forest[forest.length-1][col];
    for (int row = forest.length-2; row >= 0; row--) {
      southTree.north = forest[row][col];
      southTree = southTree.north!;
    }
  }

  int maxScenicScore = 0;
  for (final row in forest) {
    for (final tree in row) {
      final scenicScore = tree.totalScenicScore();
      if (scenicScore > maxScenicScore) {
        maxScenicScore = scenicScore;
      }
    }
  }

  print(maxScenicScore);
}
