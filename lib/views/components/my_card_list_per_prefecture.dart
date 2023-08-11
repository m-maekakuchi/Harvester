import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master_list.dart';
import '../../commons/irregular_card_number.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../widgets/infinity_list_view.dart';
import '../widgets/white_button.dart';
import 'accordion_prefectures.dart';
import 'shimmer_loading.dart';
import 'white_show_modal_bottom_sheet.dart';

class MyCardListPerPrefecture extends ConsumerStatefulWidget {
  const MyCardListPerPrefecture({super.key});

  @override
  MyCardListPerPrefectureState createState() => MyCardListPerPrefectureState();
}

class MyCardListPerPrefectureState extends ConsumerState<MyCardListPerPrefecture> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> cardMasterModelList = [];
  List<bool> myCardContainList = [];
  List<String?> imgUrlList = [];
  List<bool?> favoriteList = [];

  List<String> extractedSortedMyCardNumberList = [];  // 選択された都道府県で抽出したカード番号リスト

  //  初めに都道府県タブを押したときに、リストのアイテムを生成
  @override
  void initState() {
    getExtractedSortedMyCardNumberList();
    super.initState();
  }

  // リストのアイテムを生成
  void getExtractedSortedMyCardNumberList() {
    final myCardNumberList = [];
    myCardNumberList.addAll(ref.read(myCardNumberListProvider));
    myCardNumberList.sort();  // カード番号順に並べ替え

    final selectedPrefecture = ref.read(myCardsPagePrefectureProvider);
    int selectedPrefectureIndex = addressList.indexOf(selectedPrefecture);
    String selectedPrefectureIndexToString = (selectedPrefectureIndex + 1).toString();  //　各都道府県のカード番号はインデックス + 1
    if (selectedPrefectureIndexToString.length == 1) {  // 都道府県リストのインデックスが1桁の場合、カード番号に合わせて0をはじめにつける
      selectedPrefectureIndexToString = "0$selectedPrefectureIndexToString";
    }

    //  選択した都道府県が埼玉県か大阪府なら不規則なカード番号があるので、
    //  マイカードにその番号が含まれていたら抽出カードリストに追加
    if (irregularCardMasterNumbers.containsKey(selectedPrefecture)) {
      final String irregularCardNumber = irregularCardMasterNumbers[selectedPrefecture] as String;
      if (myCardNumberList.contains(irregularCardNumber)) {
        extractedSortedMyCardNumberList.add(irregularCardNumber);
      }
    }

    // 選択した都道府県のマイカード番号を抽出
    for (String item in myCardNumberList) {
      if (item.startsWith(selectedPrefectureIndexToString)) {
        extractedSortedMyCardNumberList.add(item);
      }
    }
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
          return const ShimmerLoading();
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
                          provider: myCardsPagePrefectureProvider,
                        )
                      );
                      // リストを初期化
                      cardMasterModelList = [];
                      myCardContainList = [];
                      imgUrlList = [];
                      favoriteList = [];
                      extractedSortedMyCardNumberList = [];
                      // リストのインデックス番号を管理するプロバイダを初期化
                      ref.read(myCardsPageFirstIndexProvider.notifier).state[tabIndex] = 0;
                      // 選択した都道府県のマイカード番号のリストを再生成
                      getExtractedSortedMyCardNumberList();
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
                      listAllItemLength: extractedSortedMyCardNumberList.length,
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