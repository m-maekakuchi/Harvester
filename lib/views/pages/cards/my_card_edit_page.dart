import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCardEditPage extends StatelessWidget {
  const MyCardEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カード編集')),
      body: Column(
          children: [
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