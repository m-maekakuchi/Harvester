import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/commons/app_const.dart';
import 'package:nil/nil.dart';

import '../../commons/address_master.dart';
import '../../commons/card_master_option_list.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import '../../repositories/card_master_repository.dart';
import '../components/accordion_prefectures.dart';
import '../components/white_show_modal_bottom_sheet.dart';
import '../widgets/white_button.dart';


class TestScrollPage extends ConsumerWidget {
  const TestScrollPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (context){
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {

        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('TabBar Demo'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "全国"),
                Tab(text: "都道府県"),
              ],
            ),
          ),
          body: const AllCardsListPage2(),
        );
      })
    );
  }
}

class AllCardsListPage2 extends StatelessWidget {
  const AllCardsListPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const TabBarView(
      children: [
        AllCardsList(),   // 「全国」タブのbody
        AllCardsListPerPrefecture(),  // 「都道府県」タブのbody
      ]
    );
  }
}

class AllCardsList extends ConsumerStatefulWidget {
  const AllCardsList({Key? key}) : super(key: key);

  @override
  AllCardsListState createState() => AllCardsListState();
}

class AllCardsListState extends ConsumerState<AllCardsList> with AutomaticKeepAliveClientMixin{
  final List<CardMasterModel> items = [];
  int lastIndex = 0;

  Future<void> getListItems() async {
    int tabIndex = DefaultTabController.of(context).index;
    await Future.delayed(const Duration(seconds: 1));

    List<CardMasterModel> newList = await CardMasterRepository().getLimitCountCardMasters(ref, tabIndex);
    for (CardMasterModel model in newList) {
      items.add(model);
    }

    lastIndex += loadingNum;
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
            items: items,
            itemsMaxIndex: cardMasterNum,
            getListItems: getListItems,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class AllCardsListPerPrefecture extends ConsumerStatefulWidget {
  const AllCardsListPerPrefecture({Key? key}) : super(key: key);

  @override
  AllCardsListPerPrefectureState createState() => AllCardsListPerPrefectureState();
}

class AllCardsListPerPrefectureState extends ConsumerState<AllCardsListPerPrefecture> with AutomaticKeepAliveClientMixin{
  List<CardMasterModel> items = [];
  int lastIndex = 0;

  Future<void> getListItems() async {
    int tabIndex = DefaultTabController.of(context).index;
    await Future.delayed(const Duration(seconds: 1));

    List<CardMasterModel> newList = await CardMasterRepository().getLimitCountCardMasters(ref, tabIndex);
    for (CardMasterModel model in newList) {
      items.add(model);
    }

    lastIndex += loadingNum;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final selectedPrefecture = ref.read(allCardsPagePrefectureProvider);  // 選択された都道府県
    final itemsMaxIndex = cardMasterOptionStrList[addressList.indexOf(selectedPrefecture)].length;

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

          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    WhiteButton(
                      text: '都道府県の選択',
                      fontSize: 16,
                      onPressed: () async {
                        // 都道府県の選択のためのModalBottomSheetを出す
                        await showWhiteModalBottomSheet(
                          context: context,
                          widget: AccordionPrefectures(
                            provider: allCardsPagePrefectureProvider,
                          )
                        );
                        // リストのアイテムを初期化
                        items = [];
                        // FireStoreから取得していたリストのlastDocumentを初期化
                        ref.read(allCardsPageLastDocumentProvider.notifier).state[1] = null;
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
                        items: items,
                        itemsMaxIndex: itemsMaxIndex,
                        getListItems: getListItems,
                      ),
                    )
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

class InfinityListView extends ConsumerStatefulWidget {
  final List<CardMasterModel> items;
  final int itemsMaxIndex;
  final Future<void> Function() getListItems;

  const InfinityListView({
    Key? key,
    required this.items,
    required this.itemsMaxIndex,
    required this.getListItems,
  }) : super(key: key);

  @override
  InfinityListViewState createState() => InfinityListViewState();
}

class InfinityListViewState extends ConsumerState<InfinityListView> {

  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      // 全てのマスターカードデータを取得していないとき
      // 現在のスクロール位置が、最大スクロールの0.95の位置を超えた、かつ読み込み中でない時
      if (
        widget.items.length != widget.itemsMaxIndex
        && _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.95
        && !_isLoading
      ) {
        _isLoading = true;

        await widget.getListItems();

        setState(() {
          _isLoading = false;
        });
      }
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

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: widget.items.length + 1,
      separatorBuilder: (BuildContext context, int index) => Container(
        width: double.infinity,
        height: 2,
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context, int index) {
        // すべてアイテムを取得した場合は、終端はなにも表示しない
        if (index < widget.itemsMaxIndex) {
          // リストが終端に行った際に、現在読み込んでるデータ+1番目の要素として、インジケーターを表示
          if (widget.items.length == index) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SizedBox(
            height: 50,
            child: Center(
              child: Text(
                widget.items[index].serialNumber,
              ),
            ),
          );
        } else {
          return nil;
        }
      },
    );
  }
}