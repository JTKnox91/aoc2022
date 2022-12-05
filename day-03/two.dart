import 'dart:io';

const values = <String, int>{
  'a': 1,
  'b': 2,
  'c': 3,
  'd': 4,
  'e': 5,
  'f': 6,
  'g': 7,
  'h': 8,
  'i': 9,
  'j': 10,
  'k': 11,
  'l': 12,
  'm': 13,
  'n': 14,
  'o': 15,
  'p': 16,
  'q': 17,
  'r': 18,
  's': 19,
  't': 20,
  'u': 21,
  'v': 22,
  'w': 23,
  'x': 24,
  'y': 25,
  'z': 26,
  'A': 27,
  'B': 28,
  'C': 29,
  'D': 30,
  'E': 31,
  'F': 32,
  'G': 33,
  'H': 34,
  'I': 35,
  'J': 36,
  'K': 37,
  'L': 38,
  'M': 39,
  'N': 40,
  'O': 41,
  'P': 42,
  'Q': 43,
  'R': 44,
  'S': 45,
  'T': 46,
  'U': 47,
  'V': 48,
  'W': 49,
  'X': 40,
  'Y': 51,
  'Z': 52,  
};

class Group {
  final Set sack1;
  final Set sack2;
  final Set sack3;

  Group(String line1, line2, line3) :
      sack1 = Set.from(line1.split('')),
      sack2 = Set.from(line2.split('')),
      sack3 = Set.from(line3.split(''));

  int get intersectionPriority {
    return values[sack1.intersection(sack2).intersection(sack3).single]!;
  }
}

void main() {

  final File inputFile = new File('one.input.txt');
  final input = <String>[];
  for (final line in inputFile.readAsLinesSync()) {
    input.add(line);
  }

  final groups = <Group>[];
  Iterable<String> remaining = input;
  while (remaining.isNotEmpty) {
    final taken = remaining.take(3).toList();

    groups.add(Group(taken[0], taken[1], taken[2]));
    remaining = remaining.skip(3);
  }

  print(groups.fold<int>(0, (sum, group) {
    return sum + group.intersectionPriority;
  }));
}