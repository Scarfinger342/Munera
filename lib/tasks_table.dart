import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'create_task_dialog.dart';
import 'group.dart';
import 'main.dart'; // For AppState
import 'task.dart';
import 'utils.dart';

// I am the greatest programmer on earth
TextStyle? getContrastingRowTextColor(Task task) {
  if (task.group != null) {
    Group group = AppState.groups.firstWhere((g) => g.id == task.group);
    return TextStyle(color: getContrastingTextColor(group.color));
  } else {
    return null;
  }
}

Color? getContrastingIconColor(Task task) {
  if (task.group != null) {
    Group group = AppState.groups.firstWhere((g) => g.id == task.group);
    return getContrastingTextColor(group.color);
  } else {
    return null;
  }
}

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
                    color: WidgetStateProperty.resolveWith<Color?>((
                      Set<WidgetState> states,
                    ) {
                      if (task.group != null) {
                        return AppState.groups
                            .firstWhere((group) => group.id == task.group)
                            .color;
                      }
                      return null;
                    }),
                    cells: <DataCell>[
                      DataCell(
                        Text(
                          task.name,
                          style: getContrastingRowTextColor(task),
                        ),
                      ),
                      DataCell(
                        Text(
                          task.status.label,
                          style: getContrastingRowTextColor(task),
                        ),
                      ),
                      DataCell(
                        Text(
                          task.due != null
                              ? DateFormat('d MMMM yyyy').format(task.due!)
                              : "",
                          style: getContrastingRowTextColor(task),
                        ),
                      ),
                      DataCell(
                        Text(
                          task.effortLevel != null
                              ? task.effortLevel!.label
                              : "",
                          style: getContrastingRowTextColor(task),
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
                          style: getContrastingRowTextColor(task),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // TODO add confirmation dialog
                            setState(() {
                              AppState.deleteTask(task.id);
                            });
                          },
                          color: getContrastingIconColor(task),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),
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
