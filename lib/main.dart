import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'taskstable.dart';
import 'kanban.dart';
import 'deadlines.dart';
import 'timeblocking.dart';

String prettyPrintJson(dynamic input) {
  var encoder = const JsonEncoder.withIndent(
    '    ',
  ); // Use two spaces for indentation

  if (input is String) {
    // If input is a String, decode it first
    final decoded = json.decode(input);
    return encoder.convert(decoded);
  } else {
    // If it's already a Map or List
    return encoder.convert(input);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory directory = await getApplicationSupportDirectory();
  final String path = directory.path;
  AppState.jsonfile = File('$path/munera.json');
  if (!await AppState.jsonfile.exists()) {
    await AppState.jsonfile.create();
    await AppState.jsonfile.writeAsString("{}");
  }
  final String json = await AppState.jsonfile.readAsString();
  AppState.data = jsonDecode(json);
  if (AppState.data.isEmpty) {
    AppState.data = AppState.defaultSettings();
    await AppState.outputJSON();
  }
  runApp(const MyApp());
}

class AppState {
  static final ValueNotifier<int> menuSelection = ValueNotifier<int>(0);
  static Map<String, dynamic> data = {};
  static late File jsonfile;
  static Map<String, dynamic> defaultSettings() {
    return {
      "settings": {
        "workLength": 25,
        "breakLength": 5,
        "longBreakLength": 15,
        "longBreakEveryTh": 4,
        "useSubjects": true,
      },
      "tasks": [],
      "groups": [],
      "timeblocks": [],
    };
  }

  static Future<void> outputJSON() async {
    await jsonfile.writeAsString(prettyPrintJson(data));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: .dark,
      home: Scaffold(
        body: Row(
          children: [
            Expanded(flex: 1, child: Sidebar()),
            Expanded(flex: 4, child: Contents()),
          ],
        ),
      ),
    );
  }
}

class Contents extends StatefulWidget {
  const Contents({super.key});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  Widget getWidget() {
    switch (AppState.menuSelection.value) {
      case 0:
        return TasksTable();
      case 1:
        return Kanban();
      case 2:
        return Deadlines();
      case 3:
        return TimeBlocking();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(8.0),
      child: ValueListenableBuilder<int>(
        valueListenable: AppState.menuSelection,
        builder: (context, value, child) {
          return getWidget();
        },
      ),
    );
  }
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  void _onItemTapped(int index) {
    setState(() {
      AppState.menuSelection.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .only(top: 32.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListView(
        padding: .zero,
        children: [
          SidebarButton(
            icon: Icons.table_view,
            text: 'Tasks Table',
            index: 0,
            onItemTapped: _onItemTapped,
          ),
          SidebarButton(
            icon: Icons.view_kanban,
            text: 'Kanban',
            index: 1,
            onItemTapped: _onItemTapped,
          ),
          SidebarButton(
            icon: Icons.calendar_month,
            text: 'Deadlines',
            index: 2,
            onItemTapped: _onItemTapped,
          ),
          SidebarButton(
            icon: Icons.calendar_view_week,
            text: 'Time Blocking',
            index: 3,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}

class SidebarButton extends StatefulWidget {
  const SidebarButton({
    super.key,
    required this.icon,
    required this.text,
    required this.index,
    required this.onItemTapped,
  });
  final void Function(int index) onItemTapped;
  final IconData icon;
  final String text;
  final int index;
  @override
  State<SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<SidebarButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListTile(
        leading: Icon(widget.icon),
        title: Text(widget.text),
        selected: AppState.menuSelection.value == widget.index,
        onTap: () {
          setState(() {
            widget.onItemTapped(widget.index);
          });
        },
      ),
    );
  }
}
