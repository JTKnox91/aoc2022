import 'dart:io';


//         [F] [Q]         [Q]        
// [B]     [Q] [V] [D]     [S]        
// [S] [P] [T] [R] [M]     [D]        
// [J] [V] [W] [M] [F]     [J]     [J]
// [Z] [G] [S] [W] [N] [D] [R]     [T]
// [V] [M] [B] [G] [S] [C] [T] [V] [S]
// [D] [S] [L] [J] [L] [G] [G] [F] [R]
// [G] [Z] [C] [H] [C] [R] [H] [P] [D]
//  1   2   3   4   5   6   7   8   9 

class Stacks{
  final stacks = <int, List<String>>{
    1: ['G', 'D', 'V', 'Z', 'J', 'S', 'B'],
    2: ['Z', 'S', 'M', 'G', 'V', 'P'],
    3: ['C', 'L', 'B', 'S', 'W', 'T', 'Q', 'F'],
    4: ['H', 'J', 'G', 'W', 'M', 'R', 'V', 'Q'],
    5: ['C', 'L', 'S', 'N', 'F', 'M', 'D'],
    6: ['R', 'G', 'C', 'D'],
    7: ['H', 'G', 'T', 'R', 'J', 'D', 'S', 'Q'],
    8: ['P', 'F', 'V'],
    9: ['D', 'R', 'S', 'T', 'J'],
  };

  move(int quanity, int from, int to) {
    final start = stacks[from]!.length - quanity;
    final end = stacks[from]!.length;
    final fromLast = stacks[from]!.sublist(start, end);
    stacks[from]!.removeRange(start, end);
    stacks[to]!.addAll(fromLast);
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  final stacks = Stacks();
  for (var line in inputFile.readAsLinesSync()) {
    if (line[0] == '#') continue;
    line = line.replaceAll('move ', '');
    line = line.replaceAll('from ', '');
    line = line.replaceAll('to ', '');
    final lineSplit = line.split(' ');
    final quantity = int.parse(lineSplit[0]);
    final from = int.parse(lineSplit[1]);
    final to = int.parse(lineSplit[2]);
    stacks.move(quantity, from, to);
  }

  var result = '';
  stacks.stacks.forEach((_key, stack) {
    result += stack.last;
  });
  print(result);
}