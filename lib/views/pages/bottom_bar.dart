import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_color.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import '../../handlers/card_master_option_list_handler.dart';
import '../../repositories/local_storage_repository.dart';
import '../../viewModels/card_master_view_model.dart';
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

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  // すべてのアイテムが表示されるように設定
        items: items,
        backgroundColor: Colors.white, // バーの色
        selectedItemColor: themeColor, // 選ばれたアイテムの色
        unselectedItemColor: textIconColor, // 選ばれていないアイテムの色
        currentIndex: index,
        onTap: (index) async {
          // 「マイカード追加」が押された場合
          if (index == 3) {
            // ローカルからマスターカードの選択肢リストを取得
            // データがない場合はfirebaseから取得してローカルに保存
            Map<String, List<String>>? list = await LocalStorageRepository().fetchCardMasterOptionMap();
            if (list == null) {
              await ref.read(cardMasterListProvider.notifier).getAllCardMasters();
              final cardMasterList = ref.watch(cardMasterListProvider);
              final cardNumberAndCityMap = makeCardMasterOptionList(cardMasterList);
              LocalStorageRepository().putCardMasterOptionMap(cardNumberAndCityMap);
            }

          }
          ref.read(indexProvider.notifier).state = index;
        },
      )
    );
  }
}

