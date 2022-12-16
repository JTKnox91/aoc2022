typedef WorryLevel WorryOperation(WorryLevel worryLevel);
typedef int BoredomOperation(WorryLevel worryLevel);
typedef void PassingOperation(int newMonkey, WorryLevel worryLevel);

class WorryLevel {
  Map<int, int> remainders = {};

  WorryLevel(int worryLevel, Iterable<int> divisorsToTrack) {
    for (final divisor in divisorsToTrack) {
      remainders[divisor] = worryLevel % divisor;
    }
  }

  WorryLevel addBy(int addend) {
    remainders.forEach((divisor, remainder) {
      remainder += addend;
      remainder %= divisor;
      remainders[divisor] = remainder;
    });
    return this;
  }

  WorryLevel multiplyBy(int factor) {
    remainders.forEach((divisor, remainder) {
      remainder *= factor;
      remainder %= divisor;
      remainders[divisor] = remainder;
    });
    return this;
  }

  WorryLevel multiplyBySelf() {
    remainders.forEach((divisor, remainder) {
      remainder *= remainder;
      remainder %= divisor;
      remainders[divisor] = remainder;
    });
    return this;
  }

  bool isDivisibleBy(int divisor) {
    if (!remainders.containsKey(divisor)) {
      throw ArgumentError('Unkown divisor: $divisor');
    }
    return remainders[divisor] == 0;
  }
}


class Monkey {
  final List<WorryLevel> items;
  final WorryOperation worryOperation;
  final BoredomOperation boredomOperation;
  final PassingOperation passingOperation;

  int inspectedCount = 0;

  Monkey(this.items, this.worryOperation, this.boredomOperation, this.passingOperation);

  void inspectEachItem() {
    for (WorryLevel item in items) {
      inspectedCount++;
      item = worryOperation(item);
      final newMonkey = boredomOperation(item);
      passingOperation(newMonkey, item);
    }
    this.items.clear();
  }
}

void main() {
  final Map<int, Monkey> monkeys = {};
  PassingOperation passingOperation = (int newMonkey, WorryLevel item) {
    monkeys[newMonkey]!.items.add(item);
  };
  // FULL INPUT
  const divisorsToTrack = [2, 3, 5, 7, 11, 13, 17, 19];
  monkeys[0] = Monkey(
    [84, 66, 62, 69, 88, 91, 91].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.multiplyBy(11),
    (worryLevel) => worryLevel.isDivisibleBy(2) ? 4 : 7,
    passingOperation);
  monkeys[1] = Monkey(
    [98, 50, 76, 99].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.multiplyBySelf(),
    (worryLevel) => worryLevel.isDivisibleBy(7) ? 3 : 6,
    passingOperation);
  monkeys[2] = Monkey(
    [72, 56, 94].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.addBy(1),
    (worryLevel) => worryLevel.isDivisibleBy(13) ? 4 : 0,
    passingOperation);
  monkeys[3] = Monkey(
    [55, 88, 90, 77, 60, 67].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.addBy(2),
    (worryLevel) => worryLevel.isDivisibleBy(3) ? 6 : 5,
    passingOperation);
  monkeys[4] = Monkey(
    [69, 72, 63, 60, 72, 52, 63, 78].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.multiplyBy(13),
    (worryLevel) => worryLevel.isDivisibleBy(19) ? 1 : 7,
    passingOperation);
  monkeys[5] = Monkey(
    [89, 73].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.addBy(5),
    (worryLevel) => worryLevel.isDivisibleBy(17) ? 2 : 0,
    passingOperation);
  monkeys[6] = Monkey(
    [78, 68, 98, 88, 66].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.addBy(6),
    (worryLevel) => worryLevel.isDivisibleBy(11) ? 2 : 5,
    passingOperation);
  monkeys[7] = Monkey(
    [70].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
    (worryLevel) => worryLevel.addBy(7),
    (worryLevel) => worryLevel.isDivisibleBy(5) ? 1 : 3,
    passingOperation);

  // // EXAMPLE INPUT
  // const divisorsToTrack = [13, 17, 19, 23];
  // monkeys[0] = Monkey(
  //   [79, 98].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
  //   (worryLevel) => worryLevel.multiplyBy(19),
  //   (worryLevel) => worryLevel.isDivisibleBy(23) ? 2 : 3,
  //   passingOperation);
  // monkeys[1] = Monkey(
  //   [54, 65, 75, 74].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
  //   (worryLevel) => worryLevel.addBy(6),
  //   (worryLevel) => worryLevel.isDivisibleBy(19) ? 2 : 0,
  //   passingOperation);
  // monkeys[2] = Monkey(
  //   [79, 60, 97].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
  //   (worryLevel) => worryLevel.multiplyBySelf(),
  //   (worryLevel) => worryLevel.isDivisibleBy(13) ? 1 : 3,
  //   passingOperation);
  // monkeys[3] = Monkey(
  //   [74].map((i) => WorryLevel(i, divisorsToTrack)).toList(),
  //   (worryLevel) => worryLevel.addBy(3),
  //   (worryLevel) => worryLevel.isDivisibleBy(17) ? 0 : 1,
  //   passingOperation);

  for (int i = 1; i <= 10000; i ++) {
    monkeys.forEach((id, monkey) {
      monkeys[id]!.inspectEachItem();
    });
  }

  monkeys.forEach((id, monkey) {
    print('Monkey $id: ${monkey.inspectedCount} items');  
  });
}