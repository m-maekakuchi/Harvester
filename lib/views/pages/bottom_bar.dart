import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/app_color.dart';
import '../../commons/app_const_num.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import '../../handlers/padding_handler.dart';
import '../components/colored_tab_bar.dart';
import 'cards/all_cards_list_page.dart';
import 'collections/my_card_add_page.dart';
import 'collections/my_cards_list_page.dart';
import 'home_page.dart';
import 'photos/photos_list_page.dart';

final indexProvider = StateProvider((ref) {
  return 0;
});

// 画面
const pages = [
  HomePage(),
  MyCardsListPage(),
  AllCardsListPage(),
  MyCardAddPage(),
  PhotosListPage(),
];

const title = [
  "My Manhole Cards",
  "My Manhole Cards",
  "All Manhole Cards",
  "My Card 追加",
  "Photo"
];

SizedBox tabBox(BuildContext context, int width, String tabName) {
  return SizedBox(
    width: getW(context, width.toDouble()),
    child: Tab(text: tabName),
  );
}

List<SizedBox> myCardTabList(BuildContext context) {
  return [
    tabBox(context, myCardAppBarTabWidth, '日付'),
    tabBox(context, myCardAppBarTabWidth, 'お気に入り'),
    tabBox(context, myCardAppBarTabWidth, '全国'),
    tabBox(context, myCardAppBarTabWidth, '都道府県'),
  ];
}

List<SizedBox> allCardTabList(BuildContext context) {
  return [
    tabBox(context, allCardAppBarTabWidth, '全国'),
    tabBox(context, allCardAppBarTabWidth, '都道府県'),
  ];
}

List<int> appBarBottomLength(BuildContext context) {
  return [
    0,
    myCardTabList(context).length,
    allCardTabList(context).length,
    0,
    0
  ];
}

SizedBox titleBox(String title, BuildContext context) {
  return SizedBox(
    width: getW(context, 60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // アイコンと文字列セットでセンターに配置
      children: [
        Image.asset(
          width: getW(context, 10),
          height: getH(context, 10),
          'images/AppBar_logo.png'
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        )
      ]
    ),
  );
}

PreferredSizeWidget appBarBottom(List<SizedBox> tabList) {
  return ColoredTabBar(
    tabBar: TabBar(
      isScrollable: true,
      indicatorColor: textIconColor,
      labelColor: textIconColor,
      labelStyle: const TextStyle(fontSize: 16),
      tabs: tabList,
    ),
  );
}

List<PreferredSizeWidget?> appBarBottomList(BuildContext context) {
  return [
    null,
    appBarBottom(myCardTabList(context)),
    appBarBottom(allCardTabList(context)),
    null,
    null
  ];
}


class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    return DefaultTabController(
      length: appBarBottomLength(context)[index],
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        // タブを切り替えたときに呼び出される
        tabController.addListener(() {});
        return Scaffold(
          appBar: AppBar(
            title: titleBox(title[index], context),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/settings/setting_page');
                },
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
            bottom: appBarBottomList(context)[index],
          ),
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,  // すべてのアイテムが表示されるように設定
            items: items,
            backgroundColor: Colors.white, // バーの色
            selectedItemColor: themeColor, // 選ばれたアイテムの色
            unselectedItemColor: textIconColor, // 選ばれていないアイテムの色
            currentIndex: index,
            onTap: (index) async {
              ref.read(indexProvider.notifier).state = index;
            },
          )
        );
      })
    );
  }
}
