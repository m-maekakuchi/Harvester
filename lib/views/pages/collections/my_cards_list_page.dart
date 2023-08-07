import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/my_card_list.dart';
import '../../components/my_card_list_per_collect_day.dart';
import '../../components/my_card_list_per_prefecture.dart';
import '../../components/my_favorite_card_list.dart';

class MyCardsListPage extends ConsumerWidget {
  const MyCardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const TabBarView(
      children: [
        MyCardList(),
        MyCardListPerPrefecture(),
        MyCardListPerCollectDay(),
        MyFavoriteCardList(),
      ]
    );
  }

}