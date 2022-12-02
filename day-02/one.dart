import 'dart:io';


class Round {
  static const playerShapeValues = <String, int>{
    'X': 1, // Rock
    'Y': 2, // Paper
    'Z': 3, // Scissors
  };

  static const outcomes = <String, int>{
    'XA': 3, // Rock v Rock : Tie
    'XB': 0, // Rock v Paper : Lose
    'XC': 6, // Rock v Scissors : Win
    'YA': 6, // Paper v Rock : Win
    'YB': 3, // Paper v Paper : Tie
    'YC': 0, // Pper v Scissors : Lose
    'ZA': 0, // Scissors v Rock : Lose
    'ZB': 6, // Scissors v Paper : Win
    'ZC': 3, // Scissors v Scissors : Tie
  };

  final String opponent;
  final String player;
  Round(this.opponent, this.player);

  int get playerScore {
    return playerShapeValues[player]! + outcomes[player+opponent]!;
  }
}

void main() {

  final File inputFile = new File('one.input.txt');
  final input = <Round>[];
  for (final line in inputFile.readAsLinesSync()) {
    input.add(Round(line[0], line[2]));
  }

  final result = input.fold<int>(0, (sum, round) {
    return sum + round.playerScore;
  });

  print(result);
}
