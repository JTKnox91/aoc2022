import 'dart:io';

class AssignmentPair {
  final int firstAssignmentLeft;
  final int firstAssignmentRight;

  final int secondAssignmentLeft;
  final int secondAssignmentRight;

  AssignmentPair(String inputLine) :
    firstAssignmentLeft = int.parse(inputLine.split(',')[0].split('-')[0]),
    firstAssignmentRight = int.parse(inputLine.split(',')[0].split('-')[1]),
    secondAssignmentLeft = int.parse(inputLine.split(',')[1].split('-')[0]),
    secondAssignmentRight = int.parse(inputLine.split(',')[1].split('-')[1]);

  bool get hasFullContain {
    if (firstAssignmentLeft <= secondAssignmentLeft && firstAssignmentRight >= secondAssignmentLeft) {
      return true;
    }
    if (secondAssignmentLeft <= firstAssignmentLeft && secondAssignmentRight >= firstAssignmentLeft) {
      return true;
    }
    return false;
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  var result = 0;
  for (final line in inputFile.readAsLinesSync()) {
    if (AssignmentPair(line).hasFullContain) {
      result++;
    }
  }

  print(result);
}