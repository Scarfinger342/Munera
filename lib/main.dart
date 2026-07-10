import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class AppState {
  static final menuSelection = ValueNotifier<int>(0);
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
  String getText() {
    switch (AppState.menuSelection.value) {
      case 0:
        return "0: Tasks Table";
      case 1:
        return "1: Kanban";
      case 2:
        return "2: Deadlines";
      case 3:
        return "3: Time Blocking";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(8.0),
      child: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: AppState.menuSelection,
          builder: (context, value, child) {
            return Text(getText(), style: TextStyle(fontSize: 40));
          },
        ),
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
