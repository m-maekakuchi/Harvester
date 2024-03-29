import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../provider/providers.dart';

class Accordion extends ConsumerWidget {
  const Accordion({
    super.key,
    required this.title,
    required this.tileTextList,
    required this.provider
  });

  /// 頭の部分のタイトル
  final String title;
  /// 開いたときのリスト
  final List<String> tileTextList;
  final StateProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = tileTextList.length;
    final GlobalKey expansionTileKey = GlobalKey(); // key property to get the current context of the ExpansionTile
    final appBarColorIndex = ref.watch(colorProvider);

    // リストタイル
    Widget listTileContainer (String title, StateProvider provider) {
      bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: textIconColor, width: 0.1),
          color: isDarkMode ? darkModeBackgroundColor : Colors.white,  // リストタイルの背景色
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: getW(context, 3)),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 文字数がオーバーしたときに横にスクロール可能
            child: Text(
              title,
              style: TextStyle(color: isDarkMode ? Colors.white : textIconColor),
            ),
          ),
          onTap: () {
            final notifier = ref.read(provider.notifier);
            notifier.state = title;
            context.pop();
          }
        )
      );
    }

    return ExpansionTile(
      collapsedTextColor: textIconColor,                              // 閉じたときの文字色
      textColor: textIconColor,                                       // 開いたときの文字色
      collapsedIconColor: textIconColor,                              // 閉じたときのアイコンの色
      iconColor: textIconColor,                                       // 開いたときのアイコンの色
      collapsedBackgroundColor: accordionColorList[appBarColorIndex], // 閉じたときの背景色
      backgroundColor: accordionColorList[appBarColorIndex],          // 開いたときの背景色
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide(color: textIconColor, width: 0.1),           // 閉じたときの枠線
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: getW(context, 3)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      key: expansionTileKey,
      onExpansionChanged: (value) {
        if (value) _scrollToSelectedContent(expansionTileKey: expansionTileKey);
      },
      children: [
        // 中身のコンテナ
        for (int i = 0; i < length; i++) ... {
          listTileContainer(tileTextList[i], provider),
        }
      ],
    );
  }

  // ExpansionTileを開いたときにスクロールする
  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
          duration: const Duration(milliseconds: 200));
      });
    }
  }
}