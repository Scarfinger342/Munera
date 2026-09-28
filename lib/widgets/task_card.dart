import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munera/main.dart';
import 'package:munera/models/task.dart';
import 'package:munera/utils.dart';
import '../widgets/colored_box.dart' as m;

// Customises what to show on screen based on the page being viewed
enum Screen {
  kanban,
  deadlines,
  timeblocking,
} // Tasks Table not present because task cards should not be used there

class TaskCard extends StatelessWidget {
  final Task task;
  final Screen screen;
  final Color color;
  const TaskCard({
    super.key,
    required this.task,
    required this.screen,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 16.0, horizontal: 32.0),
      decoration: BoxDecoration(color: color, borderRadius: .circular(15.0)),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: TextStyle(
                    fontWeight: .bold,
                    color: getContrastingTextColor(color),
                  ),
                ),
              ),
              SizedBox(width: 16),
              if (task.group != null)
                m.ColoredBox(
                  text: AppState.getGroupByID(task.group!)!.name,
                  color: AppState.getGroupByID(task.group!)!.color,
                  textColor: getContrastingTextColor(
                    AppState.getGroupByID(task.group!)!.color,
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: .center,
            children: [
              Expanded(
                child: Text(
                  DateFormat('d MMMM yyyy').format(task.due),
                  style: TextStyle(color: getContrastingTextColor(color)),
                ),
              ),
              SizedBox(width: 16),
              if (screen == .kanban) ...[
                Text('P:', style: TextStyle(fontWeight: .bold)),
                SizedBox(width: 8),
                m.ColoredBox(
                  text: task.priority.label,
                  color: task.priority.color,
                  textColor: getContrastingTextColor(task.priority.color),
                ),
              ] else if (screen == .deadlines || screen == .timeblocking) ...[
                Text('S:', style: TextStyle(fontWeight: .bold)),
                m.ColoredBox(
                  text: task.status.label,
                  color: task.status.color,
                  textColor: task.status.color != null
                      ? getContrastingTextColor(task.priority.color)
                      : null,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
