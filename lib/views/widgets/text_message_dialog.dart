import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> textMessageDialog(BuildContext context, String text) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        content: Text(text, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.center
      );
    },
  );
}