import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_const.dart';
import '../../commons/message.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../widgets/infinity_list_view.dart';
import 'error_body.dart';
import 'shimmer_loading_card_list.dart';

class AllCardList extends ConsumerStatefulWidget {
  const AllCardList({super.key});

  @override
  AllCardsListState createState() => AllCardsListState();
}

class AllCardsListState extends ConsumerState<AllCardList> with AutomaticKeepAliveClientMixin{
  final List<CardMasterModel> cardMasterModelList = [];
  final List<bool> myCardContainList = [];
  final List<String?> imgUrlList = [];
  final List<bool?> favoriteList = [];

  Future<void> getListItems() async {
    await getAllCardsPageScrollItemList(
      context,
      ref,
      cardMasterModelList,
      myCardContainList,
      imgUrlList,
      favoriteList,
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
          // bottomBarの「全カード」ボタンを押してすぐエラーになったときにここに入る
          return ErrorBody(
            errMessage: failGetDataErrorMessage,
            onPressed: () async {
              setState(() {});
            },
          );
        }
        return InfinityListView(
          cardMasterModelList: cardMasterModelList,
          myCardContainList: myCardContainList,
          imgUrlList: imgUrlList,
          favoriteList: favoriteList,
          listAllItemLength: cardMasterNum,
          getListItems: getListItems,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}