import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

class DatePicker {
  final BuildContext context;

  const DatePicker({
    required this.context
  });

  // 日付のPickerを表示
  Future<DateTime?> showDate(date) {
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor,      // ヘッダー背景色
              onPrimary: textIconColor, // ヘッダーテキストカラー
              onSurface: textIconColor, // カレンダーのテキストカラー
            ),
            textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(textIconColor), // ボタンの色
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

}
