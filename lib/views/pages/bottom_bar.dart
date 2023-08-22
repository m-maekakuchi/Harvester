import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_color.dart';
import '../../commons/app_const.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import '../../handlers/fetch_my_card_handler.dart';
import '../../provider/providers.dart';
import '../../viewModels/image_view_model.dart';
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

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomBarIndexProvider);

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  // すべてのアイテムが表示されるように設定
        items: bottomNavigationItems,
        backgroundColor: Colors.white, // バーの色
        selectedItemColor: themeColor, // 選ばれたアイテムの色
        unselectedItemColor: textIconColor, // 選ばれていないアイテムの色
        currentIndex: index,
        onTap: (index) async {
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
      )
    );
  }
}
