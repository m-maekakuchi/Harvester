import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardDetailPage extends StatelessWidget {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('マンホールカード詳細')),
        body: Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  context.push('/cards/card_edit_page');
                },
                child: Text('カード編集'),
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