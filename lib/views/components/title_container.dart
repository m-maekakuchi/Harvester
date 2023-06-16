import 'package:flutter/material.dart';

import '../../handlers/padding_handler.dart';

// ユーザーに入力or選択してもらう欄のタイトル
class TitleContainer extends StatelessWidget {

  /// タイトル
  final String titleStr;

  const TitleContainer({
    super.key,
    required this.titleStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: getW(context, 5)),
      margin: EdgeInsets.only(top: getH(context, 2), bottom: getH(context, 1)),
      child: Text(
        titleStr,
        style: const TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
