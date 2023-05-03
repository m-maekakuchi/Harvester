import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('マンホールカード一覧')),
        body: Column(
            children: [
              const Text("プロフィール登録"),
              OutlinedButton(
                onPressed: () {
                  context.go('/home_page');
                },
                child: Text('登録'),
              )
            ]
        )
    );
  }
}