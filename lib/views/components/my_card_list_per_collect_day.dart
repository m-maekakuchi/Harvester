import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/card_master_model.dart';
import '../../repositories/card_master_repository.dart';
import '../../repositories/card_repository.dart';
import '../../viewModels/auth_view_model.dart';
import '../../viewModels/user_view_model.dart';
import '../widgets/infinity_list_view.dart';
import 'shimmer_loading_card_list.dart';

class MyCardListPerCollectDay extends ConsumerStatefulWidget {
  const MyCardListPerCollectDay({super.key});

  @override
  MyCardListPerCollectDayState createState() => MyCardListPerCollectDayState();
}

class MyCardListPerCollectDayState extends ConsumerState<MyCardListPerCollectDay> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];
  List<DateTime?> collectDayList = [];


  Future<void> getListItems() async {
    int tabIndex = DefaultTabController.of(context).index;
    final uid = ref.read(authViewModelProvider.notifier).getUid();

    // await ref.read(userViewModelProvider.notifier).getOnlyCardsFromFireStore(uid);
    final myCardDocRefList = ref.read(userViewModelProvider).cards as List<DocumentReference<Map<String, dynamic>>>?;

    if (myCardDocRefList != null) {
      for (DocumentReference docRef in myCardDocRefList) {
        final cardModel = await CardRepository().getFromFireStoreUsingDocRef(docRef as DocumentReference<Map<String, dynamic>>);
        if (cardModel != null) {
          final cardMasterModel = CardMasterRepository().getCardMasterUsingDocRef(cardModel.cardMaster as DocumentReference<Map<String, dynamic>>);
          print(cardMasterModel);
          favoriteList.add(cardModel.favorite!);
          collectDayList.add(cardModel.collectDay!);

        } else {
          imgUrlList.add(null);
          favoriteList.add(null);
          collectDayList.add(null);
        }
      }
    }

    // マイカード一覧なので、trueを追加
    myCardContainList.add(true);

    // await getMyCardsPageScrollItemListAndSetIndex(
    //   tabIndex,
    //   ref,
    //   extractedSortedMyCardNumberList,
    //   cardMasterModelList,
    //   myCardContainList,
    //   imgUrlList,
    //   favoriteList
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // return Column(
    //   children: [
    //     Container(
    //       padding: EdgeInsets.only(left: getW(context, 5), top: getH(context, 2), bottom: getH(context, 1)),
    //       width: double.infinity,
    //       child: const Text(
    //         "2023年5月1日",
    //         textAlign: TextAlign.left,
    //         style: TextStyle(fontSize: 16),
    //       ),
    //     ),
    //   ],
    // );

    return FutureBuilder(
      future: getListItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoadingCardList();
        }
        if (snapshot.hasError) {
          return Text('${snapshot.stackTrace}');
        }
        return InfinityListView(
          cardMasterModelList: cardMasterModelList,
          myCardContainList: myCardContainList,
          imgUrlList: imgUrlList,
          favoriteList: favoriteList,
          listAllItemLength: 0,
          getListItems: getListItems,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
