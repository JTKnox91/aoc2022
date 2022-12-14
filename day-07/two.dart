import 'dart:io';

class Node {
  final String name;
  final Node? parent; // Only nullable for root.
  final Map<String, Node> children = {};

  int size = 0;

  Node(this.name, this.parent);

  Node goToChild(String name) {
    if (!(children.containsKey(name))) {
      throw ArgumentError('Missing child: $name');
    }
    return children[name]!;
  }

  Node goToParent() {
    if (parent == null) {
      throw ArgumentError('root has no parent');
    }
    return parent!;
  }

  void addNode(Node child) {
    children[child.name] = child;
  }

  void addLeaf(Leaf child) {
    children[child.name] = child;
    _propogateSize(child.size);
  }

  void _propogateSize(int addedSize) {
    size += addedSize;
    if (parent != null) {
      parent!._propogateSize(addedSize);
    }
  }

  List<Node> listAllDirectories() {
    final directories = <Node>[this];
    children.forEach((String name, Node node) {
      if (node is! Leaf) {
        directories.add(node);
        directories.addAll(node.listAllDirectories());
      }
    });
    return directories;
  }

  List<Leaf> listAllLeaves() {
    final leaves = <Leaf>[];
    children.forEach((String name, Node node) {
      if (node is Leaf) {
        leaves.add(node);
      } else {
        leaves.addAll(node.listAllLeaves());
      }
    });
    return leaves;
  }
}

class Leaf extends Node {
  final int size;

  Leaf(name, parent, this.size): super(name, parent);

  Node addChild(Node child) {
    throw UnimplementedError('Leaf Node cannot have children');
  }

  Node goToChild(String name) {
    throw UnimplementedError('Leaf Node cannot have children');
  }

  @override
  String toString() {
    return '${name} (${size})';
  }
}

void main() {
  const TOTAL_DISK_SPACE = 70000000;
  const REQUIRED_SPACE = 30000000;

  final File inputFile = new File('one.input.txt');
  final root = Node('/', null);
  Node currentNode = root;

  final terminalOutput = inputFile.readAsLinesSync();
  for (final line in terminalOutput) {
    final tokens = line.split(' ');
    if (tokens[0] == r'$') {
      // If command is CD, go to node
      if (tokens[1] == 'cd') {
        if (tokens[2] == '/') {
          currentNode = root;
        } else if (tokens[2] == '..') {
          currentNode = currentNode.goToParent();
        } else {
          currentNode = currentNode.goToChild(tokens[2]);
        }
      }
      // If Command is LS, add children to node.
    } else {
      if (tokens[0] == 'dir') {
        final directoryName = tokens[1];
        currentNode.addNode(Node(directoryName, currentNode));
      } else {
        final fileSize = int.parse(tokens[0]);
        final fileName = tokens[1];
        currentNode.addLeaf(Leaf(fileName, currentNode, fileSize));
      }
    }
  }

  final minimumSizeForDeletion = root.size - (TOTAL_DISK_SPACE - REQUIRED_SPACE);

  final smallestMinimumDirectory = root.listAllDirectories().reduce((smallestMinimumDirectory, directory) {
    if (directory.size > minimumSizeForDeletion && directory.size < smallestMinimumDirectory.size) {
      return directory;
    } else {
      return smallestMinimumDirectory;
    }

  });
  print(smallestMinimumDirectory.size);
}