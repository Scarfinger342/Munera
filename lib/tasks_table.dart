import 'package:flutter/material.dart';

class TasksTable extends StatefulWidget {
  const TasksTable({super.key});

  @override
  State<TasksTable> createState() => _TasksTableState();
}

class _TasksTableState extends State<TasksTable> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(onPressed: () {}, child: const Text('Show Dialog')),
    );
  }
}
