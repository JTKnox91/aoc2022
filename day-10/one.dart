import 'dart:io';

class Register {
  int x = 1;
  int cycle = 1;

  int signalStrengthSum = 0;

  _incrementCycle() {
    cycle += 1;
    if ((cycle - 20) % 40 == 0) {
      signalStrengthSum += cycle * x;
    }
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
  print(register.signalStrengthSum);
}
