import 'dart:io';

class Valve {
  final String name;
  final int flowRate;
  final Set<Valve> _immediateNeighbors = {};
  final Map<Valve, int> neighborDistances = {};

  Valve(this.name, this.flowRate);

  @override
  String toString() {
    return '$name:$flowRate';
  }

  void addImmediateNeighbors(Iterable<Valve> neighbors) {
    _immediateNeighbors.addAll(neighbors);
  }

  // Call once after all valves have added immediate neighbors
  void mapAllDistances() {
    _mapAllDistances(_immediateNeighbors, 1);
    // No need to store 0 pressure valves
    neighborDistances.removeWhere((valve, _) => valve.flowRate == 0);
  }

  void _mapAllDistances(Iterable<Valve> otherValves, int steps) {
    final List<Valve> nextIteration = [];
    otherValves.forEach((otherValve) {
      if (neighborDistances.containsKey(otherValve)) { return; }
      neighborDistances[otherValve] = steps;
      nextIteration.addAll(otherValve._immediateNeighbors);
    });
    if (nextIteration.isEmpty) { return; }
    _mapAllDistances(nextIteration, steps + 1);
  }

  int maxFlow(remainingMinutes) {
    return _maxFlow(remainingMinutes, neighborDistances.keys.toSet());
  }

  int _maxFlow(int minutes, Set<Valve> unvisted) {
    if (unvisted.isEmpty) { return 0; }
    final flowRates = <Valve, int>{};
    for (final valve in unvisted) {
      final distance = neighborDistances[valve]!;
      final remainingMunites = minutes - distance - 1;
      if (remainingMunites > 0) {
        final addedFlow = remainingMunites * valve.flowRate;
        final remainingValues = (<Valve>{...unvisted})..remove(valve);
        flowRates[valve] = addedFlow + valve._maxFlow(remainingMunites, remainingValues);
      }
    }
    return flowRates.values.fold(0, (max, current) {
      return current > max ? current : max;
    });
  }
}

void main() {
  final File inputFile = new File('input.txt');
  final Map<String, Valve> valves = {};
  for (String line in inputFile.readAsLinesSync()) {
    // Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    line = line
        .replaceAll('Valve ', '')
        .replaceAll(' has flow rate', '')
        .replaceAll(RegExp(r'; tunnels? leads? to valves?.*$'), '');
    final name = line.split('=')[0];
    final flowRate = int.parse(line.split('=')[1]);
    valves[name] = Valve(name, flowRate);
  }
  for (String line in inputFile.readAsLinesSync()) {
    // Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    line = line
        .replaceAll('Valve ', '')
        .replaceAll(RegExp(r' has flow rate=\d+; tunnels? leads? to valves? '), ', ');
    final name = line.split(', ')[0];
    valves[name]!.addImmediateNeighbors(line.split(', ').sublist(1).map<Valve>((String name) => valves[name]!));
  }

  valves.forEach((_, valve) {
    valve.mapAllDistances();
  });

  print(valves['AA']!.maxFlow(30));
}
