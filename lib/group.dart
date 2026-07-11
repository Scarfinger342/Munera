import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'color_parser.dart';

class Group {
  final String id;
  String name;
  Color color;
  DateTime createdAt;
  DateTime updatedAt;
  Group({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Group.create(String name, Color color) {
    Uuid uuid = Uuid();
    String id = uuid.v4();
    return Group(
      id: id,
      name: name,
      color: color,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }
  factory Group.fromJSON(Map<String, dynamic> object) => Group(
    id: object['id'],
    name: object['name'],
    color: (object['hex'] as String).toColor(),
    createdAt: DateTime.parse(object['createdAt']),
    updatedAt: DateTime.parse(object['updatedAt']),
  );
  Map<String, dynamic> toJSON() => {};
}
