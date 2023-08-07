import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_const.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/colored_tab_bar.dart';
import '../../components/my_card_list.dart';
import '../../components/my_card_list_per_collect_day.dart';
import '../../components/my_card_list_per_prefecture.dart';
import '../../components/my_favorite_card_list.dart';
import '../../widgets/tab_bar_of_app_bar.dart';

class MyCardsListPage extends ConsumerWidget {
  const MyCardsListPage({super.key});

  // Tab Widgetのリスト
  List<SizedBox> tabList(BuildContext context) {
    return List.generate(myCardTabTitleList.length, (index) =>
      SizedBox(
        width: getW(context, myCardAppBarTabWidth.toDouble()),
        child: Tab(text: myCardTabTitleList[index]),
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: tabList(context).length,
      child: Scaffold(
        appBar: AppBar(
          title: titleBox(pageTitleList[1], context),
          actions: actionList(context),
          bottom: ColoredTabBar(
            tabBar: tabBar(tabList(context)),
          ),
        ),
        body: const TabBarView(
          children: [
            MyCardList(),
            MyCardListPerPrefecture(),
            MyCardListPerCollectDay(),
            MyFavoriteCardList(),
          ]
        ),
      ),
    );

  }

}