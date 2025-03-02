import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game2048Screen extends StatefulWidget {
  const Game2048Screen({super.key});

  @override
  State<Game2048Screen> createState() => _Game2048ScreenState();
}

class Tile {
  int value;
  int row;
  int col;

  Tile(this.value, this.row, this.col);
}

class _Game2048ScreenState extends State<Game2048Screen> {
  List<Tile?> tiles = List.filled(16, null);
  final double tileSize = 80;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    spawnTile();
    spawnTile();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void spawnTile() {
    List<int> empty = [];
    for (int i = 0; i < 16; i++) {
      if (tiles[i] == null) empty.add(i);
    }
    if (empty.isNotEmpty) {
      int index = empty[Random().nextInt(empty.length)];
      tiles[index] = Tile(Random().nextBool() ? 2 : 4, index ~/ 4, index % 4);
    }
  }

  void slideLeft() {
    for (int row = 0; row < 4; row++) {
      mergeAndSlideRow(row);
    }
    spawnTile();
    setState(() {});
  }

  void slideRight() {
    for (int row = 0; row < 4; row++) {
      mergeAndSlideRow(row, reverse: true);
    }
    spawnTile();
    setState(() {});
  }

  void slideUp() {
    for (int col = 0; col < 4; col++) {
      mergeAndSlideColumn(col);
    }
    spawnTile();
    setState(() {});
  }

  void slideDown() {
    for (int col = 0; col < 4; col++) {
      mergeAndSlideColumn(col, reverse: true);
    }
    spawnTile();
    setState(() {});
  }

  void mergeAndSlideRow(int row, {bool reverse = false}) {
    List<Tile?> currentRow = [];

    for (int col = 0; col < 4; col++) {
      int index = row * 4 + col;
      if (tiles[index] != null) {
        currentRow.add(tiles[index]);
      }
    }

    if (reverse) {
      currentRow = currentRow.reversed.toList();
    }

    List<Tile?> newRow = [];
    int i = 0;
    while (i < currentRow.length) {
      if (i < currentRow.length - 1 && currentRow[i]!.value == currentRow[i + 1]!.value) {
        newRow.add(Tile(currentRow[i]!.value * 2, row, newRow.length));
        i += 2;
      } else {
        newRow.add(Tile(currentRow[i]!.value, row, newRow.length));
        i += 1;
      }
    }

    while (newRow.length < 4) {
      newRow.add(null);
    }

    if (reverse) {
      newRow = newRow.reversed.toList();
    }

    for (int col = 0; col < 4; col++) {
      int index = row * 4 + col;
      tiles[index] = newRow[col];
      if (tiles[index] != null) {
        tiles[index]!.row = row;
        tiles[index]!.col = col;
      }
    }
  }

  void mergeAndSlideColumn(int col, {bool reverse = false}) {
    List<Tile?> currentColumn = [];

    for (int row = 0; row < 4; row++) {
      int index = row * 4 + col;
      if (tiles[index] != null) {
        currentColumn.add(tiles[index]);
      }
    }

    if (reverse) {
      currentColumn = currentColumn.reversed.toList();
    }

    List<Tile?> newColumn = [];
    int i = 0;
    while (i < currentColumn.length) {
      if (i < currentColumn.length - 1 && currentColumn[i]!.value == currentColumn[i + 1]!.value) {
        newColumn.add(Tile(currentColumn[i]!.value * 2, newColumn.length, col));
        i += 2;
      } else {
        newColumn.add(Tile(currentColumn[i]!.value, newColumn.length, col));
        i += 1;
      }
    }

    while (newColumn.length < 4) {
      newColumn.add(null);
    }

    if (reverse) {
      newColumn = newColumn.reversed.toList();
    }

    for (int row = 0; row < 4; row++) {
      int index = row * 4 + col;
      tiles[index] = newColumn[row];
      if (tiles[index] != null) {
        tiles[index]!.row = row;
        tiles[index]!.col = col;
      }
    }
  }

  void handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          slideLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          slideRight();
          break;
        case LogicalKeyboardKey.arrowUp:
        case LogicalKeyboardKey.pageUp:
          slideUp();
          break;
        case LogicalKeyboardKey.arrowDown:
        case LogicalKeyboardKey.pageDown:
          slideDown();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: handleKeyPress,
      autofocus: true,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            slideLeft();
          } else if (details.primaryVelocity! > 0) {
            slideRight();
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            slideUp();
          } else if (details.primaryVelocity! > 0) {
            slideDown();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('เกม 2048')),
          body: Center(
            child: SizedBox(
              width: 4 * tileSize,
              height: 4 * tileSize,
              child: Stack(
                children: [
                  for (int row = 0; row < 4; row++)
                    for (int col = 0; col < 4; col++)
                      Positioned(
                        left: col * tileSize,
                        top: row * tileSize,
                        child: buildTile(row, col),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTile(int row, int col) {
    final tile = tiles[row * 4 + col];
    if (tile == null) {
      return Container(width: tileSize - 4, height: tileSize - 4, color: Colors.grey[300]);
    }
    return Container(
      width: tileSize - 4,
      height: tileSize - 4,
      color: Colors.orange[400],
      child: Center(child: Text('${tile.value}', style: const TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
