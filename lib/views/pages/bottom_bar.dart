import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_bar_contents.dart';
import '../../commons/app_color.dart';
import '../../commons/app_const.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import '../../handlers/fetch_my_card_handler.dart';
import '../../handlers/padding_handler.dart';
import '../../provider/providers.dart';
import '../components/colored_tab_bar.dart';
import 'cards/all_cards_list_page.dart';
import 'collections/my_card_add_page.dart';
import 'collections/my_cards_list_page.dart';
import 'home_page.dart';
import 'photos/photos_list_page.dart';

// 画面
const pages = [
  HomePage(),
  MyCardsListPage(),
  AllCardsListPage(),
  MyCardAddPage(),
  PhotosListPage(),
];

// タブのWidget
SizedBox tabBox(BuildContext context, int width, String tabName) {
  return SizedBox(
    width: getW(context, width.toDouble()),
    child: Tab(text: tabName),
  );
}

// マイカード一覧のTab Widgetのリスト
List<SizedBox> allCardTabList(BuildContext context) {
  return List.generate(allCardTabTitleList.length, (index) =>
    tabBox(context, allCardAppBarTabWidth, allCardTabTitleList[index])
  );
}

// 全カード一覧のTab Widgetのリスト
List<SizedBox> myCardTabList(BuildContext context) {
  return List.generate(myCardTabTitleList.length, (index) =>
    tabBox(context, myCardAppBarTabWidth, myCardTabTitleList[index])
  );
}

// 各画面のタブ数のリスト
List<int> appBarBottomLength(BuildContext context) {
  return [
    0,
    myCardTabList(context).length,
    allCardTabList(context).length,
    0,
    0
  ];
}

// TabBarのWidget
PreferredSizeWidget coloredTabBar(List<SizedBox> tabList) {
  return ColoredTabBar(
    tabBar: TabBar(
      isScrollable: true,
      indicatorColor: textIconColor,
      indicatorWeight: 4,
      labelColor: textIconColor,
      labelStyle: const TextStyle(fontSize: 16),
      tabs: tabList,
    ),
  );
}

// 各画面のTabBarを格納するリスト
List<PreferredSizeWidget?> tabBarList(BuildContext context) {
  return [
    null,
    coloredTabBar(myCardTabList(context)),
    coloredTabBar(allCardTabList(context)),
    null,
    null
  ];
}

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomBarIndexProvider);

    return DefaultTabController(
      length: appBarBottomLength(context)[index],
      child: Builder(builder: (context) {
        TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {}); // タブを切り替えたときに呼び出される
        return Scaffold(
          appBar: AppBar(
            title: titleBox(pageTitleList[index], context),
            actions: actionList(context),
            bottom: tabBarList(context)[index],
          ),
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,  // すべてのアイテムが表示されるように設定
            items: bottomNavigationItems,
            backgroundColor: Colors.white, // バーの色
            selectedItemColor: themeColor, // 選ばれたアイテムの色
            unselectedItemColor: textIconColor, // 選ばれていないアイテムの色
            currentIndex: index,
            onTap: (index) async {
              // 全カードボタンが押された場合
              if (index == 2) {
                List<Map<String, dynamic>>? myCardIdAndFavoriteList = await fetchMyCardInfoFromLocalOrDB(ref);

                // マイカード情報がローカルかFireStoreから取得できたら、マイカード情報をプロバイダで管理
                if (myCardIdAndFavoriteList != null) {
                  ref.read(myCardIdAndFavoriteListProvider.notifier).state = myCardIdAndFavoriteList;
                }
                // マイカード情報がローカルかFireStoreから取得できたら、マイカード番号をプロバイダで管理
                final myCardNumberList = [];
                if (myCardIdAndFavoriteList != null) {
                  for(Map myCardInfo in myCardIdAndFavoriteList) {
                    myCardNumberList.add(myCardInfo["id"]);
                  }
                  ref.read(myCardNumberListProvider.notifier).state = myCardNumberList;
                }
                // リストの最後のドキュメントを初期化（ページを再表示したとき、これがないとリスト表示がリセットされない）
                ref.read(allCardsPageLastDocumentProvider.notifier).state = List.filled(allCardTabTitleList.length, null);
              }
              ref.read(bottomBarIndexProvider.notifier).state = index;
            },
          )
        );
      })
    );
  }
}
