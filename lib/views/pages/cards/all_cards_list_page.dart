import 'package:flutter/material.dart';

import '../../components/all_card_List.dart';
import '../../components/all_card_List_per_prefecture.dart';

class AllCardsListPage extends StatelessWidget {
  const AllCardsListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const TabBarView(
      children: [
        AllCardList(),               // 「全国」タブのbody
        AllCardListPerPrefecture(),  // 「都道府県」タブのbody
      ]
    );
  }
}