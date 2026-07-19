import 'package:flutter/material.dart';

Color getContrastingTextColor(Color background) {
  // Returns a value between 0 (black) and 1 (white)
  final luminance = background.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}

Color darken(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
