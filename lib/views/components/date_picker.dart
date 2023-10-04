import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

class DatePicker {
  final BuildContext context;
  final int colorIndex;

  const DatePicker({
    required this.context,
    required this.colorIndex,
  });

  // 日付のPickerを表示
  Future<DateTime?> showDate(date) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColorChoice[colorIndex],                  // ヘッダー背景色
              onPrimary: textIconColor,                               // ヘッダーテキストカラー
              onSurface: isDarkMode ? Colors.white : textIconColor, // カレンダーのテキストカラー
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(
                  isDarkMode ? Colors.white : textIconColor         // ボタンの色
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

}
