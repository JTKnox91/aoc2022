import 'dart:io';

enum Shape {
  rock,
  paper,
  scissors,
}

enum Outcome {
  win,
  tie,
  lose,
}

class Round {
  static const shapeValues = <Shape, int>{
    Shape.rock: 1,
    Shape.paper: 2,
    Shape.scissors: 3,
  };

  static const outcomeValues = <Outcome, int>{
    Outcome.win: 6,
    Outcome.tie: 3,
    Outcome.lose: 0,
  };

  static const oponentShapes = <String, Shape>{
    'A': Shape.rock,
    'B': Shape.paper,
    'C': Shape.scissors,
  };

  static const playerOutcomes = <String, Outcome>{
    'X': Outcome.lose,
    'Y': Outcome.tie,
    'Z': Outcome.win,
  };

  // oponentShape -> playerOutcome -> playerShape
  static const outcomesShapes = <Shape, Map<Outcome, Shape>>{
    Shape.rock: {
      Outcome.win: Shape.paper,
      Outcome.tie: Shape.rock,
      Outcome.lose: Shape.scissors,
    },
    Shape.paper: {
      Outcome.win: Shape.scissors,
      Outcome.tie: Shape.paper,
      Outcome.lose: Shape.rock,
    },
    Shape.scissors: {
      Outcome.win: Shape.rock,
      Outcome.tie: Shape.scissors,
      Outcome.lose: Shape.paper,
    },
  };

  final Shape opponentShape;
  final Outcome playerOutcome;
  Round(String opponentText, playerText) : 
      opponentShape = oponentShapes[opponentText]!,
      playerOutcome = playerOutcomes[playerText]!;

  int get playerScore {
    final playerShape = outcomesShapes[opponentShape]![playerOutcome];
    return outcomeValues[playerOutcome]! + shapeValues[playerShape]!;
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
