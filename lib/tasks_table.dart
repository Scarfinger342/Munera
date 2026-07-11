import 'package:flutter/material.dart';
import 'create_task_dialog.dart';

class TasksTable extends StatefulWidget {
  const TasksTable({super.key});

  @override
  State<TasksTable> createState() => _TasksTableState();
}

class _TasksTableState extends State<TasksTable> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        icon: Icon(Icons.add),
        onPressed: () {
          setState(() {
            showCreateTaskDialog(context).then((task) {
              if (task != null) {
                print(task.name);
              } else {
                print('Cancelled');
              }
            });
          });
        },
        label: const Text('Add'),
      ),
    );
  }
}
