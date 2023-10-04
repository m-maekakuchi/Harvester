import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/provider/providers.dart';

import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/app_const.dart';
import '../../../commons/message.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/colored_tab_bar.dart';
import '../../components/my_card_list.dart';
import '../../components/my_card_list_per_prefecture.dart';
import '../../components/my_favorite_card_list.dart';
import '../../widgets/tab_bar_of_app_bar.dart';

class MyCardsListPage extends ConsumerWidget {
  const MyCardsListPage({super.key});

  // Tab Widgetのリスト
  List<SizedBox> tabList(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return List.generate(myCardTabTitleList.length, (index) =>
      SizedBox(
        width: getW(context, myCardAppBarTabWidth.toDouble()),
        child: Tab(
          child: Text(
            myCardTabTitleList[index],
            style: TextStyle(
              color: isDarkMode ? Colors.white : textIconColor
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCardNumber = ref.read(myCardNumberListProvider).length;
    final appBarColorIndex = ref.watch(colorProvider);

    // マイカードが登録されていない場合は、メッセージのText Widgetをタブ分生成
    List<Widget> noMyCardTextList = [];
    if (myCardNumber == 0) {
      noMyCardTextList = List.filled(myCardTabTitleList.length, const Center(child: Text(noMyCardMessage)));
    }

    return DefaultTabController(
      length: tabList(context).length,
      child: Scaffold(
        appBar: AppBar(
          title: titleBox(pageTitleList[1], context),
          actions: actionList(context),
          bottom: ColoredTabBar(
            tabBar: tabBar(tabList(context)),
          ),
          backgroundColor: themeColorChoice[appBarColorIndex],
        ),
        body: myCardNumber != 0
          ? const TabBarView(
            children: [
              MyCardList(),
              MyCardListPerPrefecture(),
              // MyCardListPerCollectDay(),
              MyFavoriteCardList(),
            ]
          )
          : TabBarView(
            children: noMyCardTextList,
          ),
      ),
    );
  }

}