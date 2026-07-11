import 'package:flutter/material.dart';

extension ColorParser on String {
  Color toColor() {
    var hexString = toUpperCase().replaceAll("#", "");
    if (hexString.length == 6) hexString = "FF$hexString";
    return Color(int.parse(hexString, radix: 16));
  }
}
