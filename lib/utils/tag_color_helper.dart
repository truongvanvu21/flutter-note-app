import 'package:flutter/material.dart';

class TagColorHelper {
  static final List<Color> tagPalette = [
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.pink.shade200,
    Colors.teal.shade200,
  ];

  static Color getTagColor(String tag) {
    int total = 0;
    for (int i = 0; i < tag.length; i++) {
      total += tag.codeUnitAt(i);
    }
    int index = total % tagPalette.length;
    return tagPalette[index];
  }

  /// Get color by index (for fallback cases)
  static Color getColorByIndex(int index) {
    return tagPalette[index % tagPalette.length];
  }
}