import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(
  BuildContext context,
  String displayName,
) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Text('Delete "$displayName"?'),
      content: const Text(
        'All related entries will be deleted. This action is irreversible!',
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.error, // Standard Material error red
            foregroundColor: Theme.of(
              context,
            ).colorScheme.onError, // Text/Icon color (usually white)
          ),
          child: const Text('Delete'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}
