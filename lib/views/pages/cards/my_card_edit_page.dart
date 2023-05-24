import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const CardEditPage());

class CardEditPage extends StatelessWidget {
  const CardEditPage({super.key});

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