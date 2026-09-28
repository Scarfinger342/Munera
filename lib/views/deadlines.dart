import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munera/utils.dart';

class Deadlines extends StatefulWidget {
  const Deadlines({super.key});

  @override
  State<Deadlines> createState() => _DeadlinesState();
}

class _DeadlinesState extends State<Deadlines> {
  late DateTime month;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    month = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0); // last day of month

    // Day-of-month number of the Monday that starts the first row (may be <= 0).
    // If the 1st is Sat/Sun, skip ahead to the following Monday so we don't
    // show an entirely grayed-out first row.
    final startDay = first.weekday <= 5
        ? 1 - (first.weekday - 1)
        : 1 + (8 - first.weekday);

    // Last Mon-Fri day in the month (if the month ends on a weekend, back up to Friday).
    final lastWeekdayDay = last.weekday <= 5
        ? last.day
        : last.day - (last.weekday - 5);

    // Number of week rows needed.
    final rowCount = ((lastWeekdayDay - startDay) ~/ 7) + 1;
    const int crossAxisCount = 5;

    return Container(
      padding: .only(top: 32.0, bottom: 32.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 32.0,
              right: 32.0,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      month = DateTime(month.year, month.month - 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(month),
                    textAlign: .center,
                    style: TextStyle(fontSize: 20, fontWeight: .bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      month = DateTime(month.year, month.month + 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tileWidth = constraints.maxWidth / crossAxisCount;
                final tileHeight = constraints.maxHeight / rowCount;
                final aspectRatio = tileWidth / tileHeight;
                // return GridView.count(
                //   crossAxisCount: crossAxisCount,
                //   physics: const NeverScrollableScrollPhysics(),
                //   childAspectRatio: aspectRatio,
                //   children: [for (var i = 0; i < 30; i++) DeadlinesDay()],
                // );
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: rowCount * crossAxisCount,
                  itemBuilder: (context, index) {
                    final row = index ~/ crossAxisCount;
                    final col = index % crossAxisCount;
                    final date = DateTime(
                      month.year,
                      month.month,
                      startDay + row * 7 + col,
                    );
                    final isCurrentMonth = date.month == month.month;
                    return DeadlinesDay(
                      isCurrentMonth: isCurrentMonth,
                      date: date,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlinesDay extends StatelessWidget {
  final bool isCurrentMonth;
  final DateTime date;
  const DeadlinesDay({
    super.key,
    required this.isCurrentMonth,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Outline color
          width: 1.0, // Outline thickness
        ),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontWeight: .bold,
              color: isCurrentMonth
                  ? null
                  : darken(Theme.of(context).colorScheme.onSurface, 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
