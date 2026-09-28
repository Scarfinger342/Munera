import 'package:flutter/material.dart';
import 'package:munera/models/task.dart';
import 'package:munera/models/group.dart';
import 'package:test/test.dart';

void main() {
  test('Task model', () {
    DateTime dueDate = DateTime.parse("2026-07-17T14:29:59.000Z");
    DateTime createdDate = DateTime.parse("2026-07-10T03:34:26.000Z");
    Map<String, dynamic> object = {
      "id": "8b58eb03-b6d9-4cea-aaee-efb33ce8c3a2",
      "name": "Test",
      "group": "809e4b6e-61a6-4abe-b71a-fabd900a6f2d",
      "status": "todo",
      "priority": "low",
      "effortLevel": "low",
      "due": "2026-07-17T14:29:59.000Z",
      "timeSpent": 60, // seconds
      "createdAt": "2026-07-10T03:34:26.000Z",
      "updatedAt": "2026-07-10T03:34:26.000Z",
    };
    Task task = Task.fromJSON(object);
    expect(task.id, "8b58eb03-b6d9-4cea-aaee-efb33ce8c3a2");
    expect(task.name, "Test");
    expect(task.group, "809e4b6e-61a6-4abe-b71a-fabd900a6f2d");
    expect(task.status, Status.todo);
    expect(task.priority, Priority.low);
    expect(task.effortLevel, EffortLevel.low);
    expect(task.due, dueDate);
    expect(task.timeSpent, 60);
    expect(task.createdAt, createdDate);
    expect(task.updatedAt, createdDate);
    Map<String, dynamic> newObject = task.toJSON();
    // ensure absolute equality
    expect(newObject, object);
  });
  test('Group model', () {
    DateTime createdDate = DateTime.parse("2026-07-10T03:34:26.000Z");
    Map<String, dynamic> object = {
      "id": "809e4b6e-61a6-4abe-b71a-fabd900a6f2d",
      "name": "Test",
      "hex": "#FFFB7B77",
      "createdAt": "2026-07-10T03:34:26.000Z",
      "updatedAt": "2026-07-10T03:34:26.000Z",
    };
    Group group = Group.fromJSON(object);
    expect(group.id, "809e4b6e-61a6-4abe-b71a-fabd900a6f2d");
    expect(group.name, "Test");
    expect(group.color, Color(0xFFFB7B77));
    expect(group.createdAt, createdDate);
    expect(group.updatedAt, createdDate);
    Map<String, dynamic> newObject = group.toJSON();
    // ensure absolute equality
    expect(newObject, object);
  });
}
