import 'package:flutter/material.dart';
import 'package:munera/main.dart';
import '../dialogs/create_group_dialog.dart';
import '../utils.dart';

class GroupDropdown extends StatefulWidget {
  final Function(String?)? onSelected;

  const GroupDropdown({super.key, this.onSelected});

  @override
  State<GroupDropdown> createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown> {
  String? selected;
  // This keyword needs to be reserved
  static const String _addCustomValue = "+";
  static const String _none = "";
  @override
  Widget build(BuildContext context) {
    // Use Strings as group IDs and a blank string for the New button
    return DropdownMenu<String>(
      initialSelection: selected,
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: _none, label: 'None'),
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
      onSelected: (value) {
        if (value == _addCustomValue) {
          showCreateGroupDialog(context).then((group) {
            if (group == null) {
              setState(() {
                selected = _none;
              });
            } else {
              setState(() {
                AppState.groups.add(group);
                AppState.outputJSON();
                selected = group.id;
                if (widget.onSelected != null) {
                  widget.onSelected!(group.id);
                }
              });
            }
          });
        } else {
          setState(() {
            selected = value;
            if (widget.onSelected != null) {
              widget.onSelected!(value);
            }
          });
        }
      },
    );
  }
}
