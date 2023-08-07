import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../widgets/infinity_list_view.dart';

class MyCardList extends ConsumerStatefulWidget {
  const MyCardList({super.key});

  @override
  MyCardListState createState() => MyCardListState();
}

class MyCardListState extends ConsumerState<MyCardList> with AutomaticKeepAliveClientMixin{
  final List<CardMasterModel> cardMasterModelList = [];
  final List<bool> myCardContainList = [];
  final List<String?> imgUrlList = [];
  final List<bool?> favoriteList = [];

  late List<String> sortedMyCardNumberList = [];  //  マイカードを番号順に並べ替えたリスト

  //  初めにマイカードボタン押したときに、リストのアイテムを生成
  @override
  void initState() {
    //  マイカード番号のリストを取得してカード番号順に並べ替え
    final myCardNumberList = ref.read(myCardNumberListProvider);
    myCardNumberList.sort();
    sortedMyCardNumberList = myCardNumberList;
    super.initState();
  }

  Future<void> getListItems() async {
    int tabIndex = DefaultTabController.of(context).index;

    await getMyCardsPageScrollItemListAndSetIndex(
      tabIndex,
      ref,
      sortedMyCardNumberList,
      cardMasterModelList,
      myCardContainList,
      imgUrlList,
      favoriteList
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: FutureBuilder(
        future: getListItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('${snapshot.stackTrace}');
          }
          return InfinityListView(
            cardMasterModelList: cardMasterModelList,
            myCardContainList: myCardContainList,
            imgUrlList: imgUrlList,
            favoriteList: favoriteList,
            listAllItemLength: ref.read(myCardNumberListProvider).length,
            getListItems: getListItems,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}