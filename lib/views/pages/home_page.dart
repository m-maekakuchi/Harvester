import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/views/components/error_body.dart';

import '../../commons/address_master.dart';
import '../../commons/message.dart';
import '../components/app_bar_contents.dart';
import '../../commons/app_color.dart';
import '../../commons/app_const.dart';
import '../../handlers/card_get_handler.dart';
import '../../handlers/indicator_data_list_handler.dart';
import '../../handlers/padding_handler.dart';
import '../../provider/providers.dart';
import '../components/indicator_custom_paint.dart';
import '../components/shimmer_loading_card_list.dart';

// インジケーターの項目
final indicatorPlace = [
  '全国',
  ...regionLengthMap.keys,
  ...addressList
];

// 地方区分の数
final areaNum = regionLengthMap.length;
// 都道府県の数
final prefectureLength = addressList.length;

// 全国、地方ごと、都道府県ごとのマイカード数のリスト
var myCardsLengthList = [];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  Future<dynamic>? myCardIdAndFavoriteList;

  @override
  void initState() {
    myCardIdAndFavoriteList = createListItems();
    super.initState();
  }

  createListItems() async {
    List<Map<String, dynamic>>? myCardIdAndFavoriteList = await getMyCardIdAndFavoriteFromLocalOrDB(ref);

    // マイカード情報がローカルかFireStoreから取得できたら、マイカード情報をプロバイダで管理
    ref.read(myCardIdAndFavoriteListProvider.notifier).state = myCardIdAndFavoriteList ?? []; // (myCardIdAndFavoriteList != null ? myCardIdAndFavoriteList : [])

    // マイカード情報がローカルかFireStoreから取得できたら、マイカード番号をプロバイダで管理
    if (myCardIdAndFavoriteList != null) {
      final myCardNumberList = myCardIdAndFavoriteList.map((value) =>
        value["id"] as String
      ).toList();
      ref.read(myCardNumberListProvider.notifier).state = myCardNumberList;
    }  else {
      ref.read(myCardNumberListProvider.notifier).state = [];
    }

    if (ref.read(allCardsLengthListProvider).isEmpty) { // 初めてホーム画面を開いたとき以外は全カード数取得をしない
      ref.read(allCardsLengthListProvider.notifier).state = createAllCardLengthList();
    }
    myCardsLengthList = createMyCardLengthList(ref);
    return myCardIdAndFavoriteList;
  }

  @override
  Widget build(BuildContext context) {
    final allCardsLengthList = ref.watch(allCardsLengthListProvider);
    final appBarColorIndex = ref.watch(colorProvider);

    final indicatorSizeAllPrefecture = getH(context, 16);
    final indicatorSizeRegion        = getH(context, 13);
    final indicatorSizePrePrefecture = getH(context, 10);

    Widget body (AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const ShimmerLoadingCardList();
      } else if (snapshot.hasError) {
        return ErrorBody(
          errMessage: failGetDataErrorMessage,
          onPressed: () {
            setState(() {
              myCardIdAndFavoriteList = createListItems();
            });
          },
        );
      } else {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: getH(context, 3),
                ),
                // 全国のインジケーター
                indicatorCustomPaint(
                  indicatorSizeAllPrefecture,
                  indicatorPlace[0],
                  myCardsLengthList[0],
                  allCardsLengthList[0],
                  context,
                  appBarColorIndex
                ),
                // 地方のインジケーター
                for (int i = 1; i <= areaNum; i += 2) ... {
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int j = 0; j <= 1; j ++) ... {
                        // 最後の行が1つ分空くので空白を設置
                        i == 9 && j == 1
                        ? Container(
                            padding: EdgeInsets.all(indicatorSizeRegion * 0.2),
                            child: SizedBox(
                              width: indicatorSizeRegion,
                              height: indicatorSizeRegion,
                            ),
                          )
                        : indicatorCustomPaint(
                            indicatorSizeRegion,
                            indicatorPlace[i + j],
                            myCardsLengthList[i + j],
                            allCardsLengthList[i + j],
                            context,
                            appBarColorIndex
                          ),
                      }
                    ],
                  ),
                },
                // 都道府県のインジケーター
                for (int i = areaNum + 1; i < prefectureLength + areaNum; i += 3) ... {
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int j = 0; j <= 2; j ++) ... {
                        // 最後の行が1つ分空くので空白を設置
                        i == prefectureLength + areaNum - 1 && j == 2
                        ? Flexible(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(indicatorSizePrePrefecture * 0.2),
                              child: SizedBox(
                                width: indicatorSizePrePrefecture,
                                height: indicatorSizePrePrefecture,
                              ),
                            ),
                          )
                        : Flexible( // デバイスによってはRowの幅をはみ出すため、はみ出したらRowの中のWidgetを収まる範囲内で分割
                            flex: 1,
                            child: indicatorCustomPaint(
                              indicatorSizePrePrefecture,
                              indicatorPlace[i + j],
                              myCardsLengthList[i + j],
                              allCardsLengthList[i + j],
                              context,
                              appBarColorIndex
                            ),
                          )
                      }
                    ],
                  )
                },
                SizedBox(
                  height: getH(context, 3),
                ),
              ],
            ),
          ),
        );
      }
    }

    return FutureBuilder(
      future: myCardIdAndFavoriteList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: titleBox(pageTitleList[0], context),
            actions: actionList(context),
            backgroundColor: themeColorChoice[appBarColorIndex],
          ),
          body: body(snapshot),
        );
      },
    );
  }
}

