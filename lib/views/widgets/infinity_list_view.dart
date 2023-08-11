import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart';

import '../../models/card_master_model.dart';
import '../components/card_short_info_container.dart';

// スクロール可能なListView
class InfinityListView extends ConsumerStatefulWidget {
  final List<CardMasterModel> cardMasterModelList;  // 一覧画面に表示するカードのリスト
  final List<bool> myCardContainList;               // マイカードに登録しているか否かのリスト
  final List<String?> imgUrlList;                   // マイカードに登録した画像URLのリスト（マイカードに登録していなければnull）
  final List<bool?> favoriteList;                   // お気に入りカードのリスト（マイカードに登録していなければnull）
  final int listAllItemLength;                      // リストの全アイテム数（全国タブ：全カード数、都道府県タブ：各都道府県のカード数）
  final Future<void> Function() getListItems;       // リスト追加のメソッド

  const InfinityListView({
    super.key,
    required this.cardMasterModelList,
    required this.myCardContainList,
    required this.imgUrlList,
    required this.favoriteList,
    required this.listAllItemLength,
    required this.getListItems,
  });

  @override
  InfinityListViewState createState() => InfinityListViewState();
}

class InfinityListViewState extends ConsumerState<InfinityListView> {

  // ScrollControllerを用いて、スクロールが終端に行ったことを検知
  late ScrollController _scrollController;
  // データ取得状況、データ取得中に再度データ取得処理が走らないよう管理
  bool _isLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    // スクロール状態を監視するリスナーを登録
    _scrollController.addListener(() async {
      // 現在のスクロール位置が、最大スクロールの0.95の位置を超えた、かつ読み込み中でない時
      // 全データ（全国タブ：全カード、都道府県タブ：各都道府県の全カード）を取得したら実行しない
      if (
        widget.favoriteList.length != widget.listAllItemLength
        && _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.95
        && !_isLoading
      ) {
        _isLoading = true;

        await widget.getListItems();

        // データ取得内容を反映
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  // ScrollControllerの破棄
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
      itemCount: widget.favoriteList.length + 1,  // データ長+1、一番最後にデータ取得が終わるfavoriteListの個数に設定
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 2),
      itemBuilder: (BuildContext context, int index) {
        // すべてアイテムを取得した場合は、終端はなにも表示しない
        if (index < widget.listAllItemLength) {
          // リストが終端に行った際に、現在読み込んでるデータ+1番目の要素として、インジケーターを表示
          // 一番最後にデータ取得が終わるfavoriteListの読み込みが終わるまで
          if (widget.favoriteList.length == index) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 10),
              CardShortInfoContainer(
                cardMasterModel: widget.cardMasterModelList[index],
                imgUrl: widget.imgUrlList[index],
                favorite: widget.favoriteList[index],
                myContain: widget.myCardContainList[index],
              ),
            ],
          );
        } else {
          return nil;
        }
      },
    );
  }
}