import 'package:flutter/material.dart';

void showMessageBox(BuildContext context, String title, String message) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ],
      );
    },
  );
}
