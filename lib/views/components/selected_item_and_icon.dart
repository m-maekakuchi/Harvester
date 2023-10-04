import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

class SelectedItemAndIcon extends StatelessWidget {

  /// 選択されたアイテム
  final String text;

  const SelectedItemAndIcon({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,  // 親の中に収まるまで縮小する。すでに収まっている場合、拡大はしない。
              child: Text(
                text,
                style: TextStyle(color: isDarkMode ? Colors.white : textIconColor),
                maxLines: 1,
              )
            ),
          ),
        ),
        Icon(
          Icons.arrow_drop_down_rounded,
          size: 40,
          color: isDarkMode ? Colors.white : textIconColor,
        ),
      ],
    );
  }
}
