import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/app_const_num.dart';
import '../../../viewModels/scroll_card_master_view_model.dart';
import '../../../viewModels/scroll_favorite_view_model.dart';
import '../../../viewModels/scroll_image_view_model.dart';
import '../../../viewModels/scroll_my_card_contain_view_model.dart';
import '../../components/card_short_info_container.dart';
import '../../components/accordion_prefectures.dart';
import '../../components/white_show_modal_bottom_sheet.dart';
import '../../widgets/white_button.dart';

final prefectureProvider = StateProvider((ref) => "");

class AllCardsListPage extends ConsumerWidget {
  const AllCardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPrefecture = ref.watch(prefectureProvider);

    Future<void> getContents() async {
      await ref.read(scrollCardMasterViewModelProvider.notifier).add();

      final cardMasterModelList = ref.read(scrollCardMasterViewModelProvider);
      await ref.read(scrollMyCardContainViewModelProvider.notifier).init(cardMasterModelList);

      final myCardContainList = ref.read(scrollMyCardContainViewModelProvider);
      await ref.read(scrollImageUrlListProvider.notifier).init(cardMasterModelList, myCardContainList);

      await ref.read(scrollFavoriteViewModelProvider.notifier).init(cardMasterModelList);
    }

    // 「全国」タブのbody
    final tabBody0 = Center(
      child: FutureBuilder(
        future: getContents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // データ取得中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('${snapshot.stackTrace}');
          }
          return InfinityListView(
            getContents: getContents,
          );
        },
      ),
    );

    // 「都道府県」タブのbody
    final tabBody1 = SingleChildScrollView(
      child: Column(
        children: [
          // 都道府県選択ボタン
          WhiteButton(
            text: '都道府県の選択',
            fontSize: 16,
            onPressed: () {
              // 都道府県の選択のためのModalBottomSheetを出す
              showWhiteModalBottomSheet(
                context: context,
                widget: AccordionPrefectures(
                  provider: prefectureProvider,
                )
              );
            },
          ),

          // 都道府県を選択したら以下が表示される
          if (selectedPrefecture != "") ... {
          }
        ],
      ),
    );

    return Scaffold(
      body: TabBarView(
        children: [
          tabBody0,
          tabBody1,
        ]
      ),
    );
  }
}

class InfinityListView extends ConsumerStatefulWidget {
  final Future<void> Function() getContents;

  const InfinityListView({
    Key? key,
    required this.getContents,
  }) : super(key: key);

  @override
  InfinityListViewState createState() => InfinityListViewState();
}

class InfinityListViewState extends ConsumerState<InfinityListView> {

  // ScrollControllerを用いて、スクロールが終端に行ったことを検知
  late ScrollController _scrollController;
  // データ取得中に再度データ取得処理が走らないよう管理
  bool _isLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      _scrollController.addListener(() async { // スクロール状態を監視するリスナーを登録

        final cardMasterList = ref.read(scrollCardMasterViewModelProvider);

        // 全てのマスターカードデータを取得していないとき
        // 現在のスクロール位置が、最大スクロールの0.95の位置を超えた、かつ読み込み中でない時
        if (
          cardMasterList.length != cardMasterNum
          && _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.95
          && !_isLoading
        ) {
          _isLoading = true;
          await widget.getContents();
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final cardMasterList = ref.watch(scrollCardMasterViewModelProvider);
    final imgUrlList = ref.watch(scrollImageUrlListProvider);
    final favoriteList = ref.watch(scrollFavoriteViewModelProvider);

    return ListView.separated(
      controller: _scrollController,
      // 一番最後にデータ取得が終わるfavoriteListの個数に設定
      itemCount: favoriteList.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 2,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        // DBに登録されているカードがまだある場合
        // マスターカードをすべて取得した場合は、終端は何も表示しない
        if (index < cardMasterNum) {
          // リストが終端に行った際に、現在読み込んでるデータ+1番目の要素として、CircularProgressIndicatorを表示する
          // cardMasterListとimgUrlListの両方読み込みが終わるまでインジケーターを表示したい
          if (cardMasterList.length == index || imgUrlList.length == index) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Column(
              children: [
                const SizedBox(height: 10),
                CardShortInfoContainer(
                  imageUrl: imgUrlList[index],
                  prefecture: cardMasterList[index].prefecture,
                  city: cardMasterList[index].city,
                  version: cardMasterList[index].version,
                  serialNumber: cardMasterList[index].serialNumber,
                  favorite: favoriteList[index],
                ),
              ],
            );
          }
        } else {
          return const SizedBox();
        }
      }
    );
  }
}