import 'package:flutter/material.dart';

class Deadlines extends StatefulWidget {
  const Deadlines({super.key});

  @override
  State<Deadlines> createState() => _DeadlinesState();
}

class _DeadlinesState extends State<Deadlines> {
  @override
  Widget build(BuildContext context) {
    const int _crossAxisCount = 5;
    const int _rowCount = 6;
    return Container(
      padding: .only(top: 32.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Month',
              style: TextStyle(fontSize: 20, fontWeight: .bold),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tileWidth = constraints.maxWidth / _crossAxisCount;
                final tileHeight = constraints.maxHeight / _rowCount;
                final aspectRatio = tileWidth / tileHeight;
                return GridView.count(
                  crossAxisCount: _crossAxisCount,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: aspectRatio,
                  children: [
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                    DeadlinesDay(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlinesDay extends StatefulWidget {
  const DeadlinesDay({super.key});

  @override
  State<DeadlinesDay> createState() => _DeadlinesDayState();
}

class _DeadlinesDayState extends State<DeadlinesDay> {
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
      child: const Placeholder(),
    );
  }
}
