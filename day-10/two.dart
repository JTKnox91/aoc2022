import 'dart:io';

class Register {
  int x = 1;
  int cycle = 1;

  List<List<String>> screen = [[]];

  _incrementCycle() {
    if (cycle % 40 == 0) {
      screen.add([]);
    }
    final crtPosition = cycle % 40;
    if (crtPosition == x || crtPosition == x+1 || crtPosition == x-1) {
      screen.last.add('X');
    } else {
      screen.last.add('.');
    }
    cycle += 1;
  }

  noop() {
    _incrementCycle();
  }

  addx(int v) {
    _incrementCycle();
    x += v;
    _incrementCycle();
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  final register = Register();
  for (final command in inputFile.readAsLinesSync()) {
    if (command == 'noop') {
      register.noop();
    } else {
      register.addx(int.parse(command.split(' ')[1]));
    }

  }

  for (final line in register.screen) {
    print(line.join(''));
  }
}
