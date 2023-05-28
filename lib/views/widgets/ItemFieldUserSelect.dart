import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import '../components/SelectedItemAndIcon.dart';

class ItemFieldUserSelect extends StatelessWidget {

  /// 選択欄に表示するテキスト
  final String text;
  final GestureTapCallback onPressed;

  const ItemFieldUserSelect({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getW(context, 90),
      height: getH(context, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: textIconColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton( // TextIconでもいいけど日付選択欄のボタンにあわせてデザイン揃えている
        padding: EdgeInsets.symmetric(horizontal: getW(context, 5)),
        onPressed: onPressed,
        child: SelectedItemAndIcon(text: text),
      ),
    );
  }
}
