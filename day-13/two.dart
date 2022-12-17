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
  final List<List> packets = [];
  int lineNumber = 0;
  for (final line in inputFile.readAsLinesSync()) {
    if (lineNumber % 3 == 0) {
      packets.add(jsonDecode(line));
    }
    if (lineNumber % 3 == 1) {
      packets.add(jsonDecode(line));
    }
    // `lineNumber % 3 == 2` is a blank line
    lineNumber++;
  }
  const divider1 = ([[2]]);
  const divider2 = ([[6]]);
  packets.add(divider1);
  packets.add(divider2);

  packets.sort((left, right) {
    final comparison = compare(left, right);
    if (comparison == true) {
      return -1;
    } else if (comparison == false) {
      return 1;
    } else {
      throw ArgumentError('Something went wrong. Comparison is null.');
    }
  });

  // Answer is indexed from 1, not 0.
  print((packets.indexOf(divider1) + 1) * (packets.indexOf(divider2) + 1));
}
