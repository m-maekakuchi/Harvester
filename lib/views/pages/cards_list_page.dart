import 'package:flutter/material.dart';

void main() => runApp(const CardsListPage());

class CardsListPage extends StatelessWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マンホールカード一覧')),
      body: const Center(
        child: Text("ログイン成功！！"),
      )
    );
  }
}