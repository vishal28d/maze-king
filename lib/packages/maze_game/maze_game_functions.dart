import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

import '../../exports.dart';

class MazeGameFunctions {
  /// *****************************************************************************
  ///                              Get winning path
  /// *****************************************************************************

  /*List<Point<int>> getWinningPath({required List<List<bool>>? mazeData, required Point<int> startBallPosition, required Point<int> destinationBallPosition}) {
    List<List<bool>> maze = mazeData ?? [];

    List<Point<int>> path = _aStar(maze, startBallPosition, destinationBallPosition);

    if (path.isNotEmpty) {
      printOkStatus("Shortest Path: $path");
      return path;
    } else {
      printOkStatus("No path found.");
      return path;
    }
  }

  List<Point<int>> _aStar(List<List<bool>> maze, Point<int> startPosition, Point<int> destinationPosition) {
    int rows = maze.length - 1;
    int cols = maze[0].length - 1;

    Point<int> start = startPosition;
    Point<int> goal = destinationPosition;

    List<Point<int>> directions = [
      const Point(-1, 0), // Up
      const Point(0, 1), // Right
      const Point(1, 0), // Down
      const Point(0, -1), // Left
    ];

    PriorityQueue<Node> openSet = PriorityQueue((a, b) => a.f.compareTo(b.f));
    Set<Point<int>> closedSet = {};

    Node startNode = Node(start, 0, _heuristic(start, goal), null);
    openSet.add(startNode);

    while (openSet.isNotEmpty) {
      Node current = openSet.removeFirst();

      if (current.position == goal) {
        // Reconstruct path
        var path = _reconstructPath(current);
        path.add(Point(rows - 1, cols));
        path.removeLast();
        return path;
      }

      closedSet.add(current.position);

      for (Point<int> direction in directions) {
        Point<int> neighbor = Point(current.position.x + direction.x, current.position.y + direction.y);

        if (_isValid(neighbor, rows, cols) && !maze[neighbor.x][neighbor.y] && !closedSet.contains(neighbor)) {
          int tentativeG = current.g + 1; // Assuming each move has a cost of 1

          Node neighborNode = Node(neighbor, tentativeG, _heuristic(neighbor, goal), current);

          if (!openSet.contains(neighborNode) || tentativeG < neighborNode.g) {
            openSet.add(neighborNode);
          }
        }
      }
    }

    // No path found
    return [];
  }

  int _heuristic(Point<int> a, Point<int> b) {
    // Manhattan distance (sum of horizontal and vertical distances)
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  bool _isValid(Point<int> position, int rows, int cols) {
    return position.x >= 0 && position.x < rows && position.y >= 0 && position.y < cols;
  }

  List<Point<int>> _reconstructPath(Node end) {
    List<Point<int>> path = [];
    Node? current = end;

    while (current != null) {
      path.insert(0, Point(current.position.x, current.position.y));
      current = current.parent;
    }

    return path;
  }*/

  static List<Point<int>> getWinningPath({
    required List<List<bool>>? mazeData,
    required Point<int> startBallPosition,
    required Point<int> destinationBallPosition,
  }) {
    final List<List<bool>> maze = mazeData ?? [];
    final List<Point<int>> path = _aStar(maze, startBallPosition, destinationBallPosition);

    if (path.isNotEmpty) {
      // printOkStatus("Shortest Path: $path");
    } else {
      printOkStatus("No path found.");
    }

    return path;
  }

  static List<Point<int>> _aStar(List<List<bool>> maze, Point<int> startPosition, Point<int> destinationPosition) {
    final int rows = maze.length - 1;
    final int cols = maze[0].length - 1;
    final Point<int> start = startPosition;
    final Point<int> goal = destinationPosition;

    final List<Point<int>> directions = [
      const Point(-1, 0), // Up
      const Point(0, 1), // Right
      const Point(1, 0), // Down
      const Point(0, -1), // Left
    ];

    final PriorityQueue<Node> openSet = PriorityQueue((a, b) => a.f.compareTo(b.f));
    final Set<Point<int>> closedSet = {};

    final Node startNode = Node(start, 0, _heuristic(start, goal), null);
    openSet.add(startNode);

    while (openSet.isNotEmpty) {
      final Node current = openSet.removeFirst();

      if (current.position == goal) {
        // Reconstruct path
        final List<Point<int>> path = _reconstructPath(current);
        path.add(Point(rows - 1, cols));
        path.removeLast();
        return path;
      }

      closedSet.add(current.position);

      for (final Point<int> direction in directions) {
        final Point<int> neighbor = Point(current.position.x + direction.x, current.position.y + direction.y);

        if (_isValid(neighbor, rows, cols) && !maze[neighbor.x][neighbor.y] && !closedSet.contains(neighbor)) {
          final int tentativeG = current.g + 1; // Assuming each move has a cost of 1

          final Node neighborNode = Node(neighbor, tentativeG, _heuristic(neighbor, goal), current);

          if (!openSet.contains(neighborNode) || tentativeG < neighborNode.g) {
            openSet.add(neighborNode);
          }
        }
      }
    }

    // No path found
    return [];
  }

  static int _heuristic(Point<int> a, Point<int> b) {
    // Manhattan distance (sum of horizontal and vertical distances)
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  static bool _isValid(Point<int> position, int rows, int cols) {
    return position.x >= 0 && position.x < rows && position.y >= 0 && position.y < cols;
  }

  static List<Point<int>> _reconstructPath(Node end) {
    final List<Point<int>> path = [];
    Node? current = end;

    while (current != null) {
      path.insert(0, Point(current.position.x, current.position.y));
      current = current.parent;
    }

    return path;
  }

  /// *****************************************************************************
  ///                              Get longest path
  /// *****************************************************************************

  static List<Point<int>> findLongestPath(List<List<bool>> maze) {
    List<Point<int>> longestPath = [];
    Map<Point<int>, Point<int>> cameFrom = {};

    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        if (!maze[i][j]) {
          Point<int> startPoint = Point(i, j);
          Point<int> endPoint = bfs(startPoint, maze);
          if (endPoint != startPoint) {
            List<Point<int>> currentPath = reconstructPath(startPoint, endPoint, cameFrom);
            if (currentPath.length > longestPath.length) {
              longestPath = currentPath;
            }
          }
        }
      }
    }

    return longestPath;
  }

  static Point<int> bfs(Point<int> start, List<List<bool>> maze) {
    Map<Point<int>, Point<int>> cameFrom = {};
    Queue<Point<int>> queue = Queue();
    Set<Point<int>> visited = {};

    queue.add(start);
    visited.add(start);

    while (queue.isNotEmpty) {
      Point<int> current = queue.removeFirst();

      for (Point<int> neighbor in getNeighbors(current, maze)) {
        if (!visited.contains(neighbor)) {
          queue.add(neighbor);
          visited.add(neighbor);
          cameFrom[neighbor] = current;
        }
      }
    }

    Point<int> lastPoint = start;
    for (Point<int> point in visited) {
      lastPoint = point;
    }

    return lastPoint;
  }

  static List<Point<int>> getNeighbors(Point<int> point, List<List<bool>> maze) {
    List<Point<int>> neighbors = [];

    if (point.x > 0 && !maze[point.x - 1][point.y]) {
      neighbors.add(Point(point.x - 1, point.y));
    }
    if (point.x < maze.length - 1 && !maze[point.x + 1][point.y]) {
      neighbors.add(Point(point.x + 1, point.y));
    }
    if (point.y > 0 && !maze[point.x][point.y - 1]) {
      neighbors.add(Point(point.x, point.y - 1));
    }
    if (point.y < maze[0].length - 1 && !maze[point.x][point.y + 1]) {
      neighbors.add(Point(point.x, point.y + 1));
    }

    return neighbors;
  }

  static List<Point<int>> reconstructPath(Point<int> start, Point<int> end, Map<Point<int>, Point<int>> cameFrom) {
    List<Point<int>> path = [];
    Point<int>? current = end;

    while (current != start && current != null) {
      path.add(current);
      current = cameFrom[current];
    }

    path.add(start);

    return path.reversed.toList();
  }
}

class Node {
  final Point<int> position;
  final int g; // cost from start to current node
  final int h; // heuristic cost (estimated cost from current node to goal)
  final int f; // total cost (g + h)
  final Node? parent;

  Node(this.position, this.g, this.h, this.parent) : f = g + h;

  @override
  String toString() {
    return 'Node{position: $position, g: $g, h: $h, f: $f}';
  }
}
