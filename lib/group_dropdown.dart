import 'package:flutter/material.dart';
import 'package:munera/main.dart';
import 'utils.dart';

class GroupDropdown extends StatefulWidget {
  const GroupDropdown({super.key});

  @override
  State<GroupDropdown> createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown> {
  String? selected;
  static const String _addCustomValue = "";
  @override
  Widget build(BuildContext context) {
    // Use Strings as group IDs and a blank string for the New button
    return DropdownMenu<String>(
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        for (var group in AppState.groups)
          DropdownMenuEntry(
            value: group.id,
            label: group.name,
            style: MenuItemButton.styleFrom(
              foregroundColor: getContrastingTextColor(group.color),
              backgroundColor: group.color,
            ),
          ),
        DropdownMenuEntry(
          value: _addCustomValue,
          label: 'Add',
          leadingIcon: Icon(Icons.add),
        ),
      ],
    );
  }
}
