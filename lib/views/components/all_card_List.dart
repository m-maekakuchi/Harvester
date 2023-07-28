import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_const.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../widgets/infinity_list_view.dart';

class AllCardList extends ConsumerStatefulWidget {
  const AllCardList({Key? key}) : super(key: key);

  @override
  AllCardsListState createState() => AllCardsListState();
}

class AllCardsListState extends ConsumerState<AllCardList> with AutomaticKeepAliveClientMixin{
  final List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];
  int lastIndex = 0;

  Future<void> getListItemsAndSetLastIndex() async {
    await getScrollItemList(
      context,
      ref,
      cardMasterModelList,
      myCardContainList,
      imgUrlList,
      favoriteList,
    );
    lastIndex += loadingNum;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: FutureBuilder(
        future: getListItemsAndSetLastIndex(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('${snapshot.stackTrace}');
          }
          return InfinityListView(
            items: cardMasterModelList,
            myCardContainList: myCardContainList,
            imgUrlList: imgUrlList,
            favoriteList: favoriteList,
            itemsMaxIndex: cardMasterNum,
            getListItems: getListItemsAndSetLastIndex,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}