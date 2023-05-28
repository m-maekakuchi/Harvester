import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';

import '../../commons/app_color.dart';
import 'cards/all_cards_list_page.dart';
import 'collections/my_card_add_page.dart';
import 'collections/my_cards_list_page.dart';
import 'home_page.dart';

final indexProvider = StateProvider((ref) {
  return 0;
});

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    // ナビゲーションバーのアイテム
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'ホーム',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_rounded),
        label: 'マイカード',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.photo_library_rounded),
        label: '全カード',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_rounded),
        label: '追加',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.photo_camera_back_rounded),
        label: '写真',
      ),
    ];

    // 画面
    const pages = [
      HomePage(),
      MyCardsListPage(),
      AllCardsListPage(),
      MyCardAddPage(),
      PhotosListPage(),
    ];

    // // AppBarのテキストタイトル
    // const appBarTextTitle = [
    //   'My Manhole Cards',
    //   'My Manhole Cards',
    //   'All Manhole Cards',
    //   'My Card 追加',
    //   'Photos'
    // ];
    //
    // // AppBarのtitle
    // final appBarTitle = [
    //   Image.asset(
    //     width: getW(context, 10),
    //     height: getH(context, 10),
    //     'images/AppBar_logo.png'
    //   ),
    //   Text(appBarTextTitle[index]),
    // ];

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
