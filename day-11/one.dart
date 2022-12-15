typedef int WorryOperation(int worryLevel);
typedef int BoredomOperation(int worryLevel);
typedef void PassingOperation(int newMonkey, int worryLevel);

class Monkey {
  final List<int> items;
  final WorryOperation worryOperation;
  final BoredomOperation boredomOperation;
  final PassingOperation passingOperation;

  int inspectedCount = 0;

  Monkey(this.items, this.worryOperation, this.boredomOperation, this.passingOperation);

  void inspectEachItem() {
    for (int item in items) {
      // print('Monkey inspects an item with a worry level of $item.');
      inspectedCount++;
      // print('Worry level changed to ${worryOperation(item)}.');
      item = worryOperation(item);
      // print('Monkey gets bored with item. Worry level is divided by 3 to ${(item / 3).floor()}.');
      item = (item / 3).floor();
      final newMonkey = boredomOperation(item);
      // print('Item with worry level ${item} is thrown to monkey $newMonkey');
      passingOperation(newMonkey, item);
    }
    this.items.clear();
  }
}

void main() {
  final Map<int, Monkey> monkeys = {};
  PassingOperation passingOperation = (int newMonkey, int item) {
    monkeys[newMonkey]!.items.add(item);
  };
  monkeys[0] = Monkey(
    [84, 66, 62, 69, 88, 91, 91],
    (worryLevel) => worryLevel * 11,
    (worryLevel) => worryLevel % 2 == 0 ? 4 : 7,
    passingOperation);
  monkeys[1] = Monkey(
    [98, 50, 76, 99],
    (worryLevel) => worryLevel * worryLevel,
    (worryLevel) => worryLevel % 7 == 0 ? 3 : 6,
    passingOperation);
  monkeys[2] = Monkey(
    [72, 56, 94],
    (worryLevel) => worryLevel + 1,
    (worryLevel) => worryLevel % 13 == 0 ? 4 : 0,
    passingOperation);
  monkeys[3] = Monkey(
    [55, 88, 90, 77, 60, 67],
    (worryLevel) => worryLevel + 2,
    (worryLevel) => worryLevel % 3 == 0 ? 6 : 5,
    passingOperation);
  monkeys[4] = Monkey(
    [69, 72, 63, 60, 72, 52, 63, 78],
    (worryLevel) => worryLevel * 13,
    (worryLevel) => worryLevel % 19 == 0 ? 1 : 7,
    passingOperation);
  monkeys[5] = Monkey(
    [89, 73],
    (worryLevel) => worryLevel + 5,
    (worryLevel) => worryLevel % 17 == 0 ? 2 : 0,
    passingOperation);
  monkeys[6] = Monkey(
    [78, 68, 98, 88, 66],
    (worryLevel) => worryLevel + 6,
    (worryLevel) => worryLevel % 11 == 0 ? 2 : 5,
    passingOperation);
  monkeys[7] = Monkey(
    [70],
    (worryLevel) => worryLevel + 7,
    (worryLevel) => worryLevel % 5 == 0 ? 1 : 3,
    passingOperation);

  for (int i = 0; i < 20; i ++) {
    monkeys.forEach((id, monkey) {
      // print('Monkey: $id');
      monkey.inspectEachItem();
    });
  }

  monkeys.forEach((id, monkey) {
    print('Monkey $id,: ${monkey.inspectedCount} items');  
  });
}