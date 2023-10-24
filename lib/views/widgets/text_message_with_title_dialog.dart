import 'package:flutter/cupertino.dart';

import '../../commons/message.dart';

Future<void> textMessageWithTitleDialog(
    BuildContext context,
    String title,
    String content,
    GestureTapCallback onPressed
  ) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content, style: const TextStyle(fontSize: 14)),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onPressed,
          child: const Text(dialogConfirmText),
        ),
      ],
    ),
  );
}