import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

class SettingAccordion extends StatelessWidget {

  /// 設定の項目
  final String title;
  /// リストのテキストとonTapの二次元配列
  final List listItemAry;

  const SettingAccordion({
    super.key,
    required this.title,
    required this.listItemAry,
  });

  @override
  Widget build(BuildContext context) {
    final length = listItemAry.length;

    return ExpansionTile(
      collapsedTextColor: textIconColor,      // 閉じたときの文字色
      textColor: textIconColor,               // 開いたときの文字色
      collapsedIconColor: textIconColor,      // 閉じたときのアイコンの色
      iconColor: textIconColor,               // 開いたときのアイコンの色
      collapsedBackgroundColor: Colors.white, // 閉じたときの背景色
      backgroundColor: Colors.white,          // 開いたときの背景色
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide(color: textIconColor, width: 0.2),   // 閉じたときの枠線
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: getW(context, 3)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      children: [
        if (length != 0) ... {
          for (int i = 0; i < length; i++) ... {
            listTileContainer(listItemAry[i][0], context, listItemAry[i][1]),
          }
        }
      ],
    );
  }

  // リストタイル
  Widget listTileContainer (String title, BuildContext context, GestureTapCallback onTap) {
    return Container(
      width: double.infinity,
      height: getH(context, 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: textIconColor, width: 0.1),
        color: Colors.grey[200],  // リストタイルの背景色
      ),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),  // リストタイルの上下のpaddingを削除
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: textIconColor),),
            const Icon(Icons.arrow_forward_ios_rounded, size: 20,)
          ],
        ),
        onTap: onTap,
      )
    );
  }

}
