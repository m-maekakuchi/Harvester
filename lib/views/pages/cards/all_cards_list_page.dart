import 'package:flutter/material.dart';

import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_const.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/all_card_list.dart';
import '../../components/all_card_list_per_prefecture.dart';
import '../../components/colored_tab_bar.dart';
import '../../widgets/tab_bar_of_app_bar.dart';

class AllCardsListPage extends StatelessWidget {
  const AllCardsListPage({super.key});

  // Tab Widgetのリスト
  List<SizedBox> tabList(BuildContext context) {
    return List.generate(allCardTabTitleList.length, (index) =>
      SizedBox(
        width: getW(context, allCardAppBarTabWidth.toDouble()),
        child: Tab(text: allCardTabTitleList[index]),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabList(context).length,
      child: Scaffold(
        appBar: AppBar(
          title: titleBox(pageTitleList[2], context),
          actions: actionList(context),
          bottom: ColoredTabBar(
            tabBar: tabBar(tabList(context)),
          ),
        ),
        body: const TabBarView(
          children: [
            AllCardList(),               // 「全国」タブのbody
            AllCardListPerPrefecture(),  // 「都道府県」タブのbody
          ]
        ),
      ),
    );
  }
}