import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'create_task_dialog.dart';
import 'main.dart'; // For AppState

class TasksTable extends StatefulWidget {
  const TasksTable({super.key});

  @override
  State<TasksTable> createState() => _TasksTableState();
}

class _TasksTableState extends State<TasksTable> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: .horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: const Text('Name')),
                DataColumn(label: const Text('Status')),
                DataColumn(label: const Text('Due Date')),
                DataColumn(label: const Text('Effort Level')),
                DataColumn(
                  label: Text(
                    AppState.settings['useSubjects'] ? 'Subject' : 'Group',
                  ),
                ),
                DataColumn(
                  headingRowAlignment: .center,
                  label: Icon(Icons.delete),
                ),
              ],
              rows: <DataRow>[
                for (var task in AppState.tasks)
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(task.name)),
                      DataCell(Text(task.status.label)),
                      DataCell(
                        Text(
                          task.due != null
                              ? DateFormat('d MMMM yyyy').format(task.due!)
                              : "",
                        ),
                      ),
                      DataCell(
                        Text(
                          task.effortLevel != null
                              ? task.effortLevel!.label
                              : "",
                        ),
                      ),
                      DataCell(
                        Text(
                          task.group != null
                              ? AppState.groups
                                    .firstWhere(
                                      (group) => group.id == task.group,
                                    )
                                    .name
                              : "",
                        ),
                      ), // TODO color rows with group color
                      DataCell(
                        IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          FilledButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              showCreateTaskDialog(context).then((task) {
                if (task != null) {
                  setState(() {
                    AppState.tasks.add(task);
                    AppState.outputJSON();
                  });
                }
              });
            },
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
