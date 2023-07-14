import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../commons/message.dart';

Future<void> messageDialog(BuildContext context, String text) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
          title: Icon(
            Icons.done_rounded,
            size: 80,
            color: textIconColor
          ),
          content: Text(registerCompleteMessage, textAlign: TextAlign.center),
      );
    },
  );
}