import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardsListPage extends StatelessWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マンホールカード一覧')),
      body: Column(
          children: [
            OutlinedButton(
              onPressed: () {
                context.go('/home_page');
              },
              child: Text('ホームページへ'),
            ),
            OutlinedButton(
              onPressed: () {
                context.go('/collections/collection_page');
              },
              child: Text('コレクション一覧へ'),
            ),
            OutlinedButton(
              onPressed: () {
                context.go('/collections/collection_add_page');
              },
              child: Text('コレクション登録へ'),
            ),
            OutlinedButton(
              onPressed: () {
                context.go('/photos/photos_list_page');
              },
              child: Text('写真一覧へ'),
            ),
            OutlinedButton(
              onPressed: () {
                context.push('/cards/card_detail_page');
              },
              child: Text('カード詳細へ'),
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