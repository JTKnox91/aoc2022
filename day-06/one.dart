import 'dart:io';

class BufferChecker {
  final List<String> input;

  // Index of char to add on `next`.
  int nextIndex;

  // Index of char to remove on `next`.
  int lastIndex;

  final Map<String, int> charCounts = {};

  int duplicateCount = 0;

  BufferChecker(this.input, int size) : nextIndex = size, lastIndex = 0 {
    for (var i = lastIndex; i < nextIndex; i++) {
      final nextChar = input[i];
      if (charCounts.containsKey(nextChar)) {
        charCounts[nextChar] = charCounts[nextChar]! + 1;
        duplicateCount++;
      } else {
        charCounts[nextChar] = 1;
      }
    }
  }

  void next() {
    if (lastIndex >= input.length) {
      throw ArgumentError('Input length exceeded');
    }

    final lastChar = input[lastIndex++];
    final nextChar = input[nextIndex++];
    if (charCounts[lastChar]! > 1) {
      charCounts[lastChar] = charCounts[lastChar]! - 1;
      duplicateCount--;
    } else {
      charCounts.remove(lastChar);
    }
    if (charCounts.containsKey(nextChar)) {
      charCounts[nextChar] = charCounts[nextChar]! + 1;
      duplicateCount++;
    } else {
      charCounts[nextChar] = 1;
    }
  }
}

void main() {
  final File inputFile = new File('one.input.txt');
  final input = inputFile.readAsLinesSync()[0].split('');

  final bufferChecker = BufferChecker(input, 4);

  while (bufferChecker.duplicateCount > 0) {
    bufferChecker.next();
  }

  print(bufferChecker.nextIndex);
}