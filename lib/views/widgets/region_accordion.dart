import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';
import 'package:harvester/handlers/padding_handler.dart';

class RegionAccordion extends ConsumerWidget {
  const RegionAccordion({
    super.key,
    required this.title,
    required this.listTileTextAry,
    required this.provider
  });

  /// 地方区分の部分の文字
  final String title;
  /// 都道府県の配列
  final List<String> listTileTextAry;
  final StateProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = listTileTextAry.length;

    return ExpansionTile(
      collapsedTextColor: textIconColor,    // 閉じたときの文字色
      textColor: textIconColor,             // 開いたときの文字色
      collapsedIconColor: textIconColor,    // 閉じたときのアイコンの色
      iconColor: textIconColor,             // 開いたときのアイコンの色
      collapsedBackgroundColor: themeColor, // 閉じたときの背景色
      backgroundColor: themeColor,          // 開いたときの背景色
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide(color: textIconColor, width: 0.1),   // 閉じたときの枠線
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: getW(context, 3)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      children: [
        // 中身のコンテナ
        for (int i = 0; i < length; i++) ... {
          listTileContainer(listTileTextAry[i], context, ref, provider),
        }
      ],
    );
  }

  // リストタイル
  Widget listTileContainer (String title, BuildContext context, WidgetRef ref, StateProvider provider) {
    return Container(
      width: double.infinity,
      height: getH(context, 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: textIconColor, width: 0.1),
        color: Colors.white,  // リストタイルの背景色
      ),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),  // リストタイルの上下のpaddingを削除
        title: Text(title, style: const TextStyle(color: textIconColor),),
        onTap: () {
          final notifier = ref.read(provider.notifier);
          notifier.state = title;
          context.pop();
        }
      )
    );
  }

}