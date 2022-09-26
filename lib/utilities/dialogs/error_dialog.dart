import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text,
    [String title = "An error occured:"]) {
  return showGenericDialog(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'Dismiss': null,
    },
  );
}
