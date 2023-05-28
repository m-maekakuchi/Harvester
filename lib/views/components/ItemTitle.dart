import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

// ユーザーに入力or選択してもらう欄のタイトル
class ItemTitle extends StatelessWidget {

  /// タイトル
  final String titleStr;

  const ItemTitle({
    super.key,
    required this.titleStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: getW(context, 5)),
      margin: EdgeInsets.only(top: getH(context, 3), bottom: getH(context, 1)),
      child: Text(
        titleStr,
        style: const TextStyle(
          fontSize: 18,
          color: textIconColor,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
