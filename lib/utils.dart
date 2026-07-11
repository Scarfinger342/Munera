import 'package:flutter/material.dart';

Color getContrastingTextColor(Color background) {
  // Returns a value between 0 (black) and 1 (white)
  final luminance = background.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}
