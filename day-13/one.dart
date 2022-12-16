import 'dart:io';
import 'dart:convert';


bool? compare(dynamic left, dynamic right) {
  if (left is int && right is int) {
    if (left < right) return true;
    if (left > right) return false;
    return null;
  } else if (left is List && right is List) {
    int i = 0;
    while (i < left.length && i < right.length) {
      final itemComparison = compare(left[i], right[i]);
      if (itemComparison != null) {
        return itemComparison;
      }
      i++;
    }
    if (left.length < right.length) return true;
    if (left.length > right.length) return false;
    return null;
  } else {
    if (left is int && right is List) {
      return compare([left], right);
    } else if (left is List && right is int) {
      return compare(left, [right]);
    } else {
      throw ArgumentError('Cannot compare $left with $right');
    }
  }
}

void main() {
  final File inputFile = new File('input.txt');
  final List<List> lefts = [];
  final List<List> rights = [];
  int lineNumber = 0;
  for (final line in inputFile.readAsLinesSync()) {
    if (lineNumber % 3 == 0) {
      lefts.add(jsonDecode(line));
    }
    if (lineNumber % 3 == 1) {
      rights.add(jsonDecode(line));
    }
    lineNumber++;
  }

  List<int> correctIndexes = [];

  for (int index = 0; index < lefts.length; index++) {
    // print('\nPAIR $index:');
    final comparison = compare(lefts[index], rights[index]);
    if (comparison == true) {
      // Answer is indexed from 1, not 0.
      correctIndexes.add(index + 1);
      // print('Inputs are in the RIGHT ORDER');
    } else if (comparison == false) {
      // print('Inputs are NOT in the right order');
    } else {
      throw ArgumentError('Something went wrong. Compasiron is null.');
    }
  }

  print(correctIndexes.reduce((sum, index) => sum + index));
}
