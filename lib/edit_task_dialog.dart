import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'group_dropdown.dart';
import 'main.dart';
import 'task.dart';

enum Property { name, group, status, effortLevel, due }

class EditTaskDialog extends StatefulWidget {
  // We take a copy of the task as a parameter to find the correct initial value
  const EditTaskDialog({super.key, required this.property, required this.task});

  final Property property;
  final Task task;
  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? group;
  late Status status;
  late EffortLevel effortLevel;
  late DateTime due;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.task.name;
    group = widget.task.group;
    status = widget.task.status;
    effortLevel = widget.task.effortLevel;
    due = widget.task.due;
  }

  Widget buildInputField(BuildContext context) {
    switch (widget.property) {
      case .name:
        return TextFormField(
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
        );
      case .group:
        return Row(
          children: [
            Text(
              AppState.settings['useSubjects'] ? "Subject" : "Group",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 20),
            GroupDropdown(
              onSelected: (value) {
                setState(() {
                  group = value == "" ? null : value; // Lord forgive me
                });
              },
            ),
          ],
        );
      case .status:
        return Row(
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
                ButtonSegment<Status>(value: .na, label: Text(Status.na.label)),
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
        );
      case .effortLevel:
        return Row(
          children: [
            const Text('Effort Level', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 20),
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
        );
      case .due:
        return Row(
          children: [
            const Text('Due Date', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 20),
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
                      due = date;
                    });
                  }
                });
              },
              child: Text(DateFormat('d MMMM yyyy').format(due)),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            children: [buildInputField(context)],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FilledButton(
          child: const Text('Save'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              switch (widget.property) {
                case .name:
                  Navigator.pop(context, nameController.text);
                  break;
                case .group:
                  Navigator.pop(
                    context,
                    group ?? "", // Differentiate between cancelled and None
                  );
                  break;
                case .status:
                  Navigator.pop(context, status);
                  break;
                case .effortLevel:
                  Navigator.pop(context, effortLevel);
                  break;
                case .due:
                  due = DateTime(
                    due.year,
                    due.month,
                    due.day,
                    23,
                    59,
                    00, // teachers never allow the extra minute that 23:59:59 has
                  ).toUtc();
                  // Do this in case the time is 23:59:30 or something
                  if (due.isBefore(DateTime.now().toUtc())) {
                    due = due.add(const Duration(days: 1));
                  }
                  Navigator.pop(context, due);
                  break;
              }
            }
          },
        ),
      ],
    );
  }
}
