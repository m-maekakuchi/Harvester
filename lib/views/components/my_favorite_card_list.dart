import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/message.dart';
import '../../handlers/padding_handler.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../widgets/infinity_list_view.dart';
import 'error_body.dart';
import 'shimmer_loading_card_list.dart';

class MyFavoriteCardList extends ConsumerStatefulWidget {
  const MyFavoriteCardList({super.key});

  @override
  MyFavoriteCardListState createState() => MyFavoriteCardListState();
}

class MyFavoriteCardListState extends ConsumerState<MyFavoriteCardList> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];

  // お気に入り登録されているマイカードを抽出して作成する、カード番号リスト
  List<String> extractedSortedMyCardNumberList = [];

  //  初めに全カードボタン押したときに、リストのアイテムを生成
  //  （スクロールしたときに毎回呼び出されないようにgetListItems()には入れない）
  @override
  void initState() {
    getExtractedSortedMyCardNumberList();
    super.initState();
  }

  // リストのアイテムを生成
  void getExtractedSortedMyCardNumberList() {
    final myCardIdAndFavoriteList = ref.read(myCardIdAndFavoriteListProvider);
    // お気に入り登録されているものだけ抽出（例： [{"id": "00-101-A001", "favorite": true}]）
    final extractedMyCardIdAndFavoriteList = myCardIdAndFavoriteList.where((value) =>
      value["favorite"] == true
    ).toList();
    // idだけ抽出
    extractedSortedMyCardNumberList = extractedMyCardIdAndFavoriteList.map((value) =>
      value["id"] as String
    ).toList();
    // 昇順に並べ替え
    extractedSortedMyCardNumberList.sort();
  }

  Future<void> getListItems() async {
    int tabIndex = DefaultTabController.of(context).index;

    await getMyCardsPageScrollItemListAndSetIndex(
      tabIndex,
      ref,
      extractedSortedMyCardNumberList,
      cardMasterModelList,
      myCardContainList,
      imgUrlList,
      favoriteList
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: getListItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoadingCardList();
        }
        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          // bottomBarの「マイカード」ボタンを押してすぐエラーになったときにここに入る
          return ErrorBody(
            errMessage: failGetDataErrorMessage,
            onPressed: () async {
              setState(() {});
            },
          );
        }
        return cardMasterModelList.isNotEmpty
          ? InfinityListView(
            cardMasterModelList: cardMasterModelList,
            myCardContainList: myCardContainList,
            imgUrlList: imgUrlList,
            favoriteList: favoriteList,
            listAllItemLength: extractedSortedMyCardNumberList.length,
            getListItems: getListItems,
          )
          : Container(
            margin: EdgeInsets.only(top: getH(context, 2)),
            child: const Text(
              textAlign: TextAlign.center,
              noFavoriteMyCard,
            ),
          );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}