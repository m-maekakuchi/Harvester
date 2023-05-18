import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';

import '../../handlers/padding_handler.dart';
import 'cards/cards_list_page.dart';
import 'collections/collection_add_page.dart';
import 'collections/collection_page.dart';
import 'home_page.dart';

final indexProvider = StateProvider((ref) {
  return 0;
});

// テキストの文字色
const textColor = Color.fromRGBO(95, 99, 104, 1);
// テーマカラー
const themeColor = Color.fromRGBO(205, 235, 195, 1.0);

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
      CollectionPage(),
      CardsListPage(),
      ColletionAddPage(),
      PhotosListPage(),
    ];

    // AppBarのテキストタイトル
    const appBarTextTitle = [
      'My Manhole Cards',
      'My Manhole Cards',
      'All Manhole Cards',
      'New My Cards',
      'Photos'
    ];

    // AppBarのtitle
    final appBarTitle = [
      Image.asset(
        width: getW(context, 10),
        height: getH(context, 10),
        'images/AppBar_logo.png'
      ),
      Text(appBarTextTitle[index]),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: appBarTitle
          ),
        ),
        iconTheme: const IconThemeData(
          size: 30,
        ),
        // leading: ,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings/setting_page');
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: textColor,
            ),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  // すべてのアイテムが表示されるように設定
        items: items,
        backgroundColor: Colors.white, // バーの色
        selectedItemColor: themeColor, // 選ばれたアイテムの色
        unselectedItemColor: textColor, // 選ばれていないアイテムの色
        currentIndex: index,
        onTap: (index) {
          ref.read(indexProvider.notifier).state = index;
        },
      )
    );
  }
}

