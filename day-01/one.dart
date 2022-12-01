import 'dart:io';
import 'dart:math';

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

  final result = input.fold(double.negativeInfinity, (num maxSoFar, List<num> element) {
    return max<num>(maxSoFar, element.reduce((num sum, num element) {
      return sum + element;
    }));
  });


  print(result);
}
