import 'package:flutter/material.dart';
import 'package:munera/models/group.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:munera/utils.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key});

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  Color color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Group'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Color', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) => color,
                      ),
                    ),
                    child: Text(
                      'Select',
                      style: TextStyle(color: getContrastingTextColor(color)),
                    ),
                    onPressed: () {
                      final Color colorBeforeDialog = color;
                      colorPicker(context).then((result) {
                        if (!result) {
                          setState(() {
                            color = colorBeforeDialog;
                          });
                        }
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
              final group = Group.create(
                name: nameController.text,
                color: color,
              );
              Navigator.pop(context, group);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<bool> colorPicker(BuildContext context) async {
    return ColorPicker(
      color: color,
      onColorChanged: (Color color) => setState(() => this.color = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyLarge,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(
        minHeight: 460,
        minWidth: 300,
        maxWidth: 320,
      ),
    );
  }
}

Future<Group?> showCreateGroupDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => CreateGroupDialog(),
  );
}
