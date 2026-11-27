import 'package:flutter/material.dart';

class Bottle {
  final List<Color> colors;
  final int capacity;

  Bottle({required List<Color> colors, this.capacity = 4})
      : colors = List.from(colors);

  bool get isFull => colors.length >= capacity;
  bool get isEmpty => colors.isEmpty;
  bool get isMonochrome {
    if (isEmpty) return true;
    if (colors.length < capacity) return false;
    final first = colors.first;
    return colors.every((c) => c == first);
  }

  Color? get topColor => isEmpty ? null : colors.last;

  Bottle clone() => Bottle(colors: List.from(colors), capacity: capacity);
}

class GameLevel {
  final int levelNumber;
  final List<Bottle> bottles;

  GameLevel({required this.levelNumber, required this.bottles});
}
