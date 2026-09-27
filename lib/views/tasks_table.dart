import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munera/dialogs/confirm_delete_dialog.dart';
import 'package:munera/dialogs/edit_task_dialog.dart';
import '../dialogs/create_task_dialog.dart';
import '../models/group.dart';
import '../main.dart'; // For AppState
import '../models/task.dart';
import '../utils.dart';

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
    return Container(
      padding: .all(32.0),
      child: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: .horizontal,
              child: SingleChildScrollView(
                scrollDirection: .vertical,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: const Text('Name')),
                    DataColumn(label: const Text('Priority')),
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditTaskDialog(property: .name, task: task),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .name =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Container(
                              padding: .symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: task
                                    .priority
                                    .color, // null is an accepted value
                              ),
                              child: Text(
                                task.priority.label,
                                style: task.status.color != null
                                    ? TextStyle(
                                        color: getContrastingTextColor(
                                          task.priority.color,
                                        ),
                                      )
                                    : getContrastingRowTextColor(task),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTaskDialog(
                                  property: .priority,
                                  task: task,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .priority =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Container(
                              padding: .symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTaskDialog(
                                  property: .status,
                                  task: task,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .status =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Text(
                              DateFormat('d MMMM yyyy').format(task.due),
                              style: getContrastingRowTextColor(task),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditTaskDialog(property: .due, task: task),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .due =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Container(
                              padding: .symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: task.effortLevel.color,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                task.effortLevel.label,
                                style: TextStyle(
                                  color: getContrastingTextColor(
                                    task.effortLevel.color,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTaskDialog(
                                  property: .effortLevel,
                                  task: task,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .effortLevel =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Text(
                              task.group != null
                                  ? AppState.getGroupByID(task.group!)!.name
                                  : "",
                              style: getContrastingRowTextColor(task),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTaskDialog(
                                  property: .group,
                                  task: task,
                                ),
                              ).then((value) {
                                if (value != null && value != "") {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .group =
                                        value; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                } else if (value == "") {
                                  setState(() {
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .group =
                                        null; // Make sure we edit the original and not a copy
                                    AppState.tasks
                                            .firstWhere((t) => t.id == task.id)
                                            .updatedAt =
                                        DateTime.now();
                                    AppState.outputJSON();
                                  });
                                }
                              });
                            },
                          ),
                          DataCell(
                            Icon(
                              Icons.delete,
                              color: getContrastingIconColor(task),
                            ),
                            onTap: () {
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
      ),
    );
  }
}
