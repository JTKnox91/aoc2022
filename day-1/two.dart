import 'dart:io';

void main() {
  final File inputFile = new File('one.input.txt');
  final List<List<num>> input = [[]];
  for (final line in inputFile.readAsLinesSync()) {
    if (line == '') {
      input.add([]);
    } else {
      input.last.add(num.parse(line));
    }
  }

  final List<num> top3 = [double.negativeInfinity, double.negativeInfinity, double.negativeInfinity];

  input.map<num>((List<num> element) {
    return element.reduce((num sum, num element) {
      return sum + element;
    });
  }).forEach((element) {
    if (element > top3[0]) {
      top3.insert(0, element);
      top3.removeLast();
      return;
    }
    if (element > top3[1]) {
       top3.insert(1, element);
      top3.removeLast();
      return;
    }
    if (element > top3[2]) {
       top3.insert(2, element);
      top3.removeLast();
      return;
    }
  });

  print(top3[0] + top3[1] + top3[2]);
}
