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

class Sack {
  final Set compartment1;
  final Set compartment2;

  Sack(String line) :
      compartment1 = Set.from(line.substring(0, (line.length / 2).floor()).split('')),
      compartment2 = Set.from(line.substring((line.length / 2).floor()).split(''));

  int get intersectionPriority {
    return values[compartment1.intersection(compartment2).single]!;
  }
}


void main() {

  final File inputFile = new File('one.input.txt');
  final input = <Sack>[];
  for (final line in inputFile.readAsLinesSync()) {
    input.add(Sack(line));
  }

  print(input.fold<int>(0, (sum, sack) {
    return sum + sack.intersectionPriority;
  }));
}