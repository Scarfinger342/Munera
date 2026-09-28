import 'package:flutter/material.dart';
import 'package:munera/main.dart';
import 'package:munera/models/task.dart';
import 'package:munera/widgets/group_dropdown.dart';
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
  Priority priority = .low;
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
                  Spacer(),
                  DropdownMenu<Status>(
                    initialSelection: status,
                    onSelected: (Status? newSelection) {
                      setState(() {
                        status = newSelection!;
                      });
                    },
                    dropdownMenuEntries: Status.values
                        .map(
                          (Status s) => DropdownMenuEntry<Status>(
                            value: s,
                            label: s.label,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Priority', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  DropdownMenu<Priority>(
                    initialSelection: priority,
                    onSelected: (Priority? newSelection) {
                      setState(() {
                        priority = newSelection!;
                      });
                    },
                    dropdownMenuEntries: Priority.values
                        .map(
                          (Priority s) => DropdownMenuEntry<Priority>(
                            value: s,
                            label: s.label,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Effort Level', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  DropdownMenu<EffortLevel>(
                    initialSelection: effortLevel,
                    onSelected: (EffortLevel? newSelection) {
                      setState(() {
                        effortLevel = newSelection!;
                      });
                    },
                    dropdownMenuEntries: EffortLevel.values
                        .map(
                          (EffortLevel s) => DropdownMenuEntry<EffortLevel>(
                            value: s,
                            label: s.label,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Deadline', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
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
                priority: priority,
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
