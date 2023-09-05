import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../commons/message.dart';

Future<void> textMessageDialog(BuildContext context, String text) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(text, style: const TextStyle(fontSize: 16)),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            context.pop();
          },
          child: Text(dialogConfirmText),
        ),
      ],
    ),
  );
}