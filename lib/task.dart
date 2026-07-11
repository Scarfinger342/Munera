import 'package:uuid/uuid.dart';

enum Status {
  todo("Todo"),
  inprogress("In Progress"),
  done("Done"),
  na("N/A");

  final String label;
  const Status(this.label);
}

enum EffortLevel {
  low("Low"),
  medium("Medium"),
  high("High");

  final String label;
  const EffortLevel(this.label);
}

class Task {
  final String id;
  String name;
  String? group;
  Status status;
  EffortLevel? effortLevel;
  DateTime? due;
  final DateTime createdAt;
  DateTime updatedAt;
  Task({
    required this.id,
    required this.name,
    this.group,
    required this.status,
    this.effortLevel,
    this.due,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Task.create(
    String name,
    String? group,
    Status? status,
    EffortLevel? effortLevel,
    DateTime? due,
  ) {
    Uuid uuid = Uuid();
    String id = uuid.v4();
    return Task(
      id: id,
      name: name,
      group: group,
      status: status ?? Status.todo,
      effortLevel: effortLevel,
      due: due,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }
  factory Task.fromJSON(Map<String, dynamic> object) => Task(
    id: object['id'],
    name: object['name'],
    group: object.containsKey('group') ? object['group'] : null,
    status: Status.values.byName(object['status']),
    effortLevel: object.containsKey('effortLevel')
        ? EffortLevel.values.byName(object['effortLevel'])
        : null,
    due: object.containsKey('due') ? DateTime.parse(object['due']) : null,
    createdAt: DateTime.parse(object['createdAt']),
    updatedAt: DateTime.parse(object['updatedAt']),
  );
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> out = {
      'id': id,
      'name': name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    if (group != null) out['group'] = group;
    if (effortLevel != null) out['effortLevel'] = effortLevel!.name;
    if (due != null) out['due'] = due!.toIso8601String();
    return out;
  }
}
