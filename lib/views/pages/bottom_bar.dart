import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';

import '../../commons/app_color.dart';
import '../../commons/bottom_navigation_bar_item.dart';
import 'cards/all_cards_list_page.dart';
import 'collections/my_card_add_page.dart';
import 'collections/my_cards_list_page.dart';
import 'home_page.dart';

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
        onTap: (index) {
          ref.read(indexProvider.notifier).state = index;
        },
      )
    );
  }
}

