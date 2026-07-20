import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils.dart';

class Kanban extends StatefulWidget {
  const Kanban({super.key});

  @override
  State<Kanban> createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 50.0,
      children: [
        Container(
          width: 200,
          color: darken(Status.todo.color!, 0.3),
          child: Column(
            children: [Container(height: 200, color: Status.todo.color!)],
          ),
        ), // Todo
        Container(
          width: 200,
          color: darken(Status.inprogress.color!, 0.3),
          child: Column(
            children: [Container(height: 200, color: Status.inprogress.color!)],
          ),
        ), // In Progress
        Container(
          width: 200,
          color: darken(Status.done.color!, 0.3),
          child: Column(
            children: [Container(height: 200, color: Status.done.color!)],
          ),
        ), // Done
      ],
    );
  }
}
