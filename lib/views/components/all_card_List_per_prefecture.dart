import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master_list.dart';
import '../../commons/app_const.dart';
import '../../commons/card_master_option_list.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../widgets/infinity_list_view.dart';
import '../widgets/white_button.dart';
import 'accordion_prefectures.dart';
import 'white_show_modal_bottom_sheet.dart';

class AllCardListPerPrefecture extends ConsumerStatefulWidget {
  const AllCardListPerPrefecture({Key? key}) : super(key: key);

  @override
  AllCardsListPerPrefectureState createState() => AllCardsListPerPrefectureState();
}

class AllCardsListPerPrefectureState extends ConsumerState<AllCardListPerPrefecture> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> cardMasterModelList = [];
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

    final selectedPrefecture = ref.read(allCardsPagePrefectureProvider);  // 選択された都道府県
    final selectedPrefectureCardsNum = cardMasterOptionStrList[addressList.indexOf(selectedPrefecture)].length;  // 選択された都道府県のカード枚数

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
                        // FireStoreから取得していたリストのlastDocumentを初期化
                        ref.read(allCardsListLastDocumentProvider.notifier).state[tabIndex] = null;
                        // リストのインデックスを初期化
                        lastIndex = 0;
                        // 再ビルド
                        setState(() {});
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: double.infinity,
                      child: Text(selectedPrefecture, style: const TextStyle(fontSize: 18)),
                    ),
                    Expanded(
                      child: InfinityListView(
                        items: cardMasterModelList,
                        myCardContainList: myCardContainList,
                        imgUrlList: imgUrlList,
                        favoriteList: favoriteList,
                        itemsMaxIndex: selectedPrefectureCardsNum,
                        getListItems: getListItemsAndSetLastIndex,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}