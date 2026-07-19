import 'package:flutter/material.dart';
import 'main.dart';
import 'task.dart';
import 'group_dropdown.dart';
import 'package:intl/intl.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? selectedGroup;
  Status status = .todo;
  EffortLevel effortLevel = .low;
  DateTime dueDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Task'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Status', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  SegmentedButton<Status>(
                    segments: <ButtonSegment<Status>>[
                      ButtonSegment<Status>(
                        value: .todo,
                        label: Text(Status.todo.label),
                      ),
                      ButtonSegment<Status>(
                        value: .inprogress,
                        label: Text(Status.inprogress.label),
                      ),
                      ButtonSegment<Status>(
                        value: .done,
                        label: Text(Status.done.label),
                      ),
                      ButtonSegment<Status>(
                        value: .na,
                        label: Text(Status.na.label),
                      ),
                    ],
                    selected: <Status>{status},
                    onSelectionChanged: (Set<Status> newSelection) {
                      setState(() {
                        status = newSelection.first;
                      });
                    },
                    showSelectedIcon: false,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Effort Level', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  SegmentedButton<EffortLevel>(
                    segments: <ButtonSegment<EffortLevel>>[
                      ButtonSegment<EffortLevel>(
                        value: .low,
                        label: Text(EffortLevel.low.label),
                      ),
                      ButtonSegment<EffortLevel>(
                        value: .medium,
                        label: Text(EffortLevel.medium.label),
                      ),
                      ButtonSegment<EffortLevel>(
                        value: .high,
                        label: Text(EffortLevel.high.label),
                      ),
                    ],
                    selected: <EffortLevel>{effortLevel},
                    onSelectionChanged: (Set<EffortLevel> newSelection) {
                      setState(() {
                        effortLevel = newSelection.first;
                      });
                    },
                    showSelectedIcon: false,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Due Date', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        // TODO make it impossible to create a task at 23:59 that is due on the same day
                        firstDate: DateTime.now(),
                        lastDate: DateTime(9999),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            dueDate = date;
                          });
                        }
                      });
                    },
                    child: Text(DateFormat('d MMMM yyyy').format(dueDate)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    AppState.settings['useSubjects'] ? "Subject" : "Group",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  GroupDropdown(
                    onSelected: (value) {
                      setState(() {
                        selectedGroup = value == ""
                            ? null
                            : value; // Lord forgive me
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              dueDate = DateTime(
                dueDate.year,
                dueDate.month,
                dueDate.day,
                23,
                59,
                00, // teachers never allow the extra minute that 23:59:59 has
              ).toUtc();
              // Do this in case the time is 23:59:30 or something
              if (dueDate.isBefore(DateTime.now().toUtc())) {
                dueDate = dueDate.add(const Duration(days: 1));
              }
              final Task task = Task.create(
                name: nameController.text,
                status: status,
                effortLevel: effortLevel,
                due: dueDate,
                group: selectedGroup,
              );
              Navigator.pop(context, task);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

Future<Task?> showCreateTaskDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => CreateTaskDialog(),
  );
}
