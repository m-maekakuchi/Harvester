import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master.dart';
import '../../commons/card_master_option_list.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../widgets/infinity_list_view.dart';
import '../widgets/white_button.dart';
import 'accordion_prefectures.dart';
import 'shimmer_loading_card_list.dart';
import 'white_show_modal_bottom_sheet.dart';

class AllCardListPerPrefecture extends ConsumerStatefulWidget {
  const AllCardListPerPrefecture({super.key});

  @override
  AllCardsListPerPrefectureState createState() => AllCardsListPerPrefectureState();
}

class AllCardsListPerPrefectureState extends ConsumerState<AllCardListPerPrefecture> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];

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

    final selectedPrefecture = ref.read(allCardsPagePrefectureProvider);  // 選択された都道府県
    final selectedPrefectureCardsNum = cardMasterOptionStrList[addressList.indexOf(selectedPrefecture)].length;  // 選択された都道府県のカード枚数

    return FutureBuilder(
      future: getListItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoadingCardList();
        }
        if (snapshot.hasError) {
          return Text('${snapshot.stackTrace}');
        }
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  WhiteButton(
                    text: '都道府県の選択',
                    fontSize: 16,
                    onPressed: () async {
                      int tabIndex = DefaultTabController.of(context).index;

                      // 都道府県の選択のためのModalBottomSheetを出す
                      await showWhiteModalBottomSheet(
                        context: context,
                        widget: AccordionPrefectures(
                          provider: allCardsPagePrefectureProvider,
                        )
                      );
                      // リストを初期化
                      cardMasterModelList = [];
                      myCardContainList = [];
                      imgUrlList = [];
                      favoriteList = [];
                      // FireStoreから取得していたlastDocumentを初期化
                      ref.read(allCardsPageLastDocumentProvider.notifier).state[tabIndex] = null;
                      // 再ビルド
                      setState(() {});
                    },
                  ),
                  Expanded(
                    child: InfinityListView(
                      cardMasterModelList: cardMasterModelList,
                      myCardContainList: myCardContainList,
                      imgUrlList: imgUrlList,
                      favoriteList: favoriteList,
                      listAllItemLength: selectedPrefectureCardsNum,
                      getListItems: getListItems,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}