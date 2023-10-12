import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../commons/app_color.dart';
import '../../commons/app_const.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import '../../provider/providers.dart';
import '../../viewModels/image_view_model.dart';
import '../widgets/ad_banner.dart';
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
  // PhotosListPage(),
];

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final currentIndex = ref.watch(bottomBarIndexProvider);
    final loadingState = ref.watch(loadingIndicatorProvider);
    final appBarColorIndex = ref.watch(colorProvider);

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(                                                // AdMob 広告
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            alignment: Alignment.center,
            child: AdWidget(ad: bannerAd),
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,                    // すべてのアイテムが表示されるように設定
            items: bottomNavigationItems,
            backgroundColor: isDarkMode
              ? Colors.black
              : Colors.white,                                       // バーの背景色
            selectedItemColor: themeColorChoice[appBarColorIndex],  // 選ばれたアイテムの色
            unselectedItemColor: isDarkMode
              ? Colors.white
              : textIconColor,                                      // 選ばれていないアイテムの色
            currentIndex: currentIndex,
            onTap: loadingState                                     // ローディング中は全ボタン押せないようにする
              ? null
              : (index) async {
                // 現在のインデックスと同じボタンを選択したらなにもしない
                if (currentIndex == index) return;
                // マイカードボタンか全カードボタンが押されたとき
                if (index == 1 || index == 2) {
                  // リストの最後のドキュメントを初期化（ページを再表示したとき、これがないとリスト表示がリセットされない）
                  if (index == 1) ref.read(myCardsPageFirstIndexProvider.notifier).state = List.filled(myCardTabTitleList.length, 0);
                  if (index == 2) ref.read(allCardsPageLastDocumentProvider.notifier).state = List.filled(allCardTabTitleList.length, null);
                }

                // 追加ボタンが押されたとき
                if (index == 3) {
                  //  追加画面の画像が残っている場合があるのでViewModelを初期化
                  ref.read(imageListProvider.notifier).init();
                }

                ref.read(bottomBarIndexProvider.notifier).state = index;
              },
          ),
        ],
      )
    );
  }
}
