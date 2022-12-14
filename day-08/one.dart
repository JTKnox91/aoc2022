import 'dart:io';

void main() {
  final File inputFile = new File('one.input.txt');
  final List<List<int>> forest = [];
  for (final line in inputFile.readAsLinesSync()) {
    forest.add(line.split('').map((String digit) => int.parse(digit)).toList());
  }

  final visibleCoords = <String>{};

  // Rows left to right
  for (int row = 0; row < forest.length; row++) {
    int tallestFromLeft = -1;
    for (int col = 0; col < forest.first.length; col++) {
      if (forest[row][col] > tallestFromLeft) {
        visibleCoords.add('$row,$col');
        tallestFromLeft = forest[row][col];
      }
    }
  }

  // Rows right to left
  for (int row = 0; row < forest.length; row++) {
    int tallestFromRight = -1;
    for (int col = forest.first.length-1; col >= 0; col--) {
      if (forest[row][col] > tallestFromRight) {
        visibleCoords.add('$row,$col');
        tallestFromRight = forest[row][col];
      }
    }
  }

  // Cols top to bottom
  for (int col = 0; col < forest.first.length; col++) {
    int tallestFromTop = -1;
    for (int row = 0; row < forest.length; row++) {
      if (forest[row][col] > tallestFromTop) {
        visibleCoords.add('$row,$col');
        tallestFromTop = forest[row][col];
      }
    }
  }

  // Cols bottom to top
  for (int col = 0; col < forest.first.length; col++) {
    int tallestFromBottom = -1;
    for (int row = forest.length-1; row >= 0; row--) {
      if (forest[row][col] > tallestFromBottom) {
        visibleCoords.add('$row,$col');
        tallestFromBottom = forest[row][col];
      }
    }
  }

  print(visibleCoords.length);
}
