import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munera/confirm_delete_dialog.dart';
import 'create_task_dialog.dart';
import 'group.dart';
import 'main.dart'; // For AppState
import 'task.dart';
import 'utils.dart';

// I am the greatest programmer on earth
TextStyle? getContrastingRowTextColor(Task task) {
  if (task.group != null) {
    Group group = AppState.getGroupByID(
      task.group!,
    )!; // TODO handle broken reference error in all similar function calls
    return TextStyle(color: getContrastingTextColor(group.color));
  } else {
    return null;
  }
}

Color? getContrastingIconColor(Task task) {
  if (task.group != null) {
    Group group = AppState.getGroupByID(task.group!)!;
    return getContrastingTextColor(group.color);
  } else {
    return Colors.white; // ensuring consistency
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
            child: SingleChildScrollView(
              scrollDirection: .vertical,
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
                          return AppState.getGroupByID(task.group!)!.color;
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
                          Container(
                            padding: .symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: task
                                  .status
                                  .color, // null is an accepted value
                            ),
                            child: Text(
                              task.status != .na ? task.status.label : "",
                              style: task.status.color != null
                                  ? TextStyle(
                                      color: getContrastingTextColor(
                                        task.status.color!,
                                      ),
                                    )
                                  : getContrastingRowTextColor(task),
                            ),
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
                          Container(
                            padding: .symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: task.effortLevel?.color,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              task.effortLevel != null
                                  ? task.effortLevel!.label
                                  : "",
                              style: task.effortLevel != null
                                  ? TextStyle(
                                      color: getContrastingTextColor(
                                        task.effortLevel!.color,
                                      ),
                                    )
                                  : getContrastingRowTextColor(task),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            task.group != null
                                ? AppState.getGroupByID(task.group!)!.name
                                : "",
                            style: getContrastingRowTextColor(task),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showConfirmDeleteDialog(context, task.name).then((
                                result,
                              ) {
                                if (result != null && result == true) {
                                  setState(() {
                                    AppState.deleteTask(task.id);
                                  });
                                }
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
