import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String msg,
    [String title = "Error:"]) {
  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Dismiss')),
        ],
      );
    }),
  );
}
