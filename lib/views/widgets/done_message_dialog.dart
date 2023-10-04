import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

Future<void> doneMessageDialog(BuildContext context, String message) {
  bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,  // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        title: Icon(
          Icons.done_rounded,
          size: 60,
          color: isDarkMode ? Colors.white : textIconColor
        ),
        content: Text(message, textAlign: TextAlign.center),
      );
    },
  );
}