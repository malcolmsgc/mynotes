import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context,
    [String title = "Delete Note"]) {
  return showGenericDialog(
    context: context,
    title: title,
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
