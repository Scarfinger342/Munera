import 'package:flutter/material.dart';
import 'package:munera/main.dart';
import '../models/task.dart';
import '../utils.dart';

class Kanban extends StatelessWidget {
  const Kanban({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        final isWide = constraints.maxWidth > 940;
        return isWide
            ? Row(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                spacing: 50.0,
                children: [
                  // TODO drag and drop
                  KanbanColumn(status: Status.todo, scrollable: true),
                  KanbanColumn(status: Status.inprogress, scrollable: true),
                  KanbanColumn(status: Status.done, scrollable: true),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: .vertical,
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: 50.0,
                  children: [
                    // TODO drag and drop
                    KanbanColumn(status: Status.todo),
                    KanbanColumn(status: Status.inprogress),
                    KanbanColumn(status: Status.done),
                  ],
                ),
              );
      }),
    );
  }
}

class KanbanColumn extends StatefulWidget {
  const KanbanColumn({super.key, required this.status, this.scrollable = true});
  final Status status;
  final bool scrollable;
  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = AppState.tasks
        .where((task) => task.status == widget.status)
        .toList();
    return Container(
      clipBehavior: .antiAlias,
      width: widget.scrollable ? 280 : null,
      decoration: BoxDecoration(
        color: darken(widget.status.color!, 0.3),
        borderRadius: .circular(15.0),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Container(
            padding: .all(8.0),
            color: widget.status.color!,
            child: Text(
              widget.status.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                color: getContrastingTextColor(widget.status.color!),
              ),
              textAlign: .center,
            ),
          ),
          Container(
            padding: .all(8.0),
            color: darken(widget.status.color!, 0.15),
            child: Text(
              "Tasks: ${tasks.length}",
              style: TextStyle(
                fontSize: 16,
                color: getContrastingTextColor(
                  darken(widget.status.color!, 0.15),
                ),
              ),
            ),
          ),
          // Tasks list
          conditionalScrollWrap(
            widget.scrollable,
            .vertical,
            const Placeholder(),
          ),
        ],
      ),
    );
  }
}

Widget conditionalScrollWrap(bool wrap, Axis scrollDirection, Widget widget) {
  if (wrap) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      child: widget,
    );
  } else {
    return widget;
  }
}

Widget conditionalExpandedWrap(bool wrap, Axis scrollDirection, Widget widget) {
  if (wrap) {
    return Expanded(child: widget);
  } else {
    return widget;
  }
}
