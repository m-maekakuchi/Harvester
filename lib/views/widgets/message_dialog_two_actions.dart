import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// actionボタンが2つある場合のダイアログ
Future<void> messageDialogTwoActions(
    BuildContext context,
    String titleText,
    Widget? content,
    String popText,
    String pushText,
    GestureTapCallback pushOnPressed
  ) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(titleText),
      content: content,
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            context.pop();
          },
          child: Text(popText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: pushOnPressed,
          child: Text(pushText),
        ),
      ],
    ),
  );
}