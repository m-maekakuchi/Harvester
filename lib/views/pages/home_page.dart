import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              context.go('/collections/collection_page');
            },
            child: Text('コレクション一覧'),
          ),
          OutlinedButton(
            onPressed: () {
              context.go('/cards/cards_list_page');
            },
            child: Text('カード一覧'),
          ),
          OutlinedButton(
            onPressed: () {
              context.go('/collections/collection_add_page');
            },
            child: Text('コレクション登録'),
          ),
          OutlinedButton(
            onPressed: () {
              context.go('/photos/photos_list_page');
            },
            child: Text('写真一覧'),
          ),
          OutlinedButton(
            onPressed: () {
              context.go('/settings/setting_page');
            },
            child: Text('設定'),
          ),
        ]
      )
    );
  }
}