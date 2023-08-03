import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_const.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../widgets/infinity_list_view.dart';

class AllCardList extends ConsumerStatefulWidget {
  const AllCardList({super.key});

  @override
  AllCardsListState createState() => AllCardsListState();
}

class AllCardsListState extends ConsumerState<AllCardList> with AutomaticKeepAliveClientMixin{
  final List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];

  Future<void> getListItems() async {
    await getScrollItemList(
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
            listAllItemLength: cardMasterNum,
            getListItems: getListItems,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}