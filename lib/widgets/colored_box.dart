import 'package:flutter/material.dart';

class ColoredBox extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  const ColoredBox({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
    );
  }
}
