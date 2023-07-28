import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/commons/app_const.dart';
import 'package:nil/nil.dart';

import '../../commons/address_master_list.dart';
import '../../commons/card_master_option_list.dart';
import '../../handlers/scroll_items_handler.dart';
import '../../models/card_master_model.dart';
import '../../models/card_model.dart';
import '../../provider/providers.dart';
import '../../repositories/card_master_repository.dart';
import '../../repositories/card_repository.dart';
import '../../repositories/image_repository.dart';
import '../../repositories/photo_repository.dart';
import '../../viewModels/auth_view_model.dart';
import '../components/accordion_prefectures.dart';
import '../components/all_card_List.dart';
import '../components/all_card_List_per_prefecture.dart';
import '../components/card_short_info_container.dart';
import '../components/white_show_modal_bottom_sheet.dart';
import '../widgets/infinity_list_view.dart';
import '../widgets/white_button.dart';


class TestPage2 extends ConsumerWidget {
  const TestPage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (context){
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {});
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
        AllCardList(),               // 「全国」タブのbody
        AllCardListPerPrefecture(),  // 「都道府県」タブのbody
      ]
    );
  }
}

// class AllCardList extends ConsumerStatefulWidget {
//   const AllCardList({Key? key}) : super(key: key);
//
//   @override
//   AllCardsListState createState() => AllCardsListState();
// }
//
// class AllCardsListState extends ConsumerState<AllCardList> with AutomaticKeepAliveClientMixin{
//   final List<CardMasterModel> cardMasterModelList = [];
//   List<bool> myCardContainList = [];
//   List<String?> imgUrlList = [];
//   List<bool?> favoriteList = [];
//
//   int lastIndex = 0;
//
//   Future<void> getListItemsAndSetLastIndex() async {
//     await getScrollItemList(
//       context,
//       ref,
//       cardMasterModelList,
//       myCardContainList,
//       imgUrlList,
//       favoriteList,
//     );
//
//     // int tabIndex = DefaultTabController.of(context).index;
//     // await Future.delayed(const Duration(seconds: 1));
//     //
//     // List<CardMasterModel> newCardMasterModelList = await CardMasterRepository().getLimitCountCardMasters(ref, tabIndex);
//     // for (CardMasterModel model in newCardMasterModelList) {
//     //   cardMasterModelList.add(model);
//     // }
//     //
//     // final myCardInfoList = ref.read(myCardInfoListProvider);
//     // // final myCardSerialNumberList = ref.read(myCardNumberListProvider);
//     // final myCardSerialNumberList = ["02-201-A001", "02-202-A001", "02-205-A001", "03-202-B001", "01-100-A001", "00-101-A001", "01-100-B001"];
//     //
//     // // マイカードに含まれているかどうかのリスト
//     // List<bool> newMyCardContainList = [];
//     // for (CardMasterModel cardMasterModel in newCardMasterModelList) {
//     //   final myCardContain = myCardSerialNumberList.contains(cardMasterModel.serialNumber);
//     //   newMyCardContainList.add(myCardContain);
//     // }
//     // for (bool myCardContain in newMyCardContainList) {
//     //   myCardContainList.add(myCardContain);
//     // }
//     //
//     //
//     // final uid = ref.read(authViewModelProvider.notifier).getUid();
//     // int i = 0;
//     // /// ListのforEachでasync, awaitを使用するときはFuture.forEachじゃないと処理順番が期待通りにならない
//     // await Future.forEach(newCardMasterModelList, (item) async {
//     //   if (newMyCardContainList[i]) {
//     //     CardModel? cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${newCardMasterModelList[i].serialNumber}");
//     //     if (cardModel != null && cardModel.photos!.isNotEmpty) {
//     //       final photoFirstDocRef = cardModel.photos![0] as DocumentReference<Map<String, dynamic>>;
//     //       final photoModel = await PhotoRepository().getFromFireStore(photoFirstDocRef);
//     //       if (photoModel != null) {
//     //         final imgUrl = await ImageRepository().downloadOneImageFromFireStore(newCardMasterModelList[i].serialNumber, photoModel.fileName!, ref);
//     //         imgUrlList.add(imgUrl);
//     //       } else {
//     //         imgUrlList.add(null);
//     //       }
//     //     } else {
//     //       imgUrlList.add(null);
//     //     }
//     //   } else {
//     //     imgUrlList.add(null);
//     //   }
//     //   i++;
//     // });
//     //
//     // for (CardMasterModel cardMasterModel in newCardMasterModelList) {
//     //   if (myCardSerialNumberList.contains(cardMasterModel.serialNumber)) {
//     //     int index = myCardInfoList.indexWhere((element) => element["id"] == cardMasterModel.serialNumber);
//     //     // newMyFavoriteList.add(myCardInfoList[index]["favorite"]);
//     //     favoriteList.add(false);
//     //   } else {
//     //     favoriteList.add(null);
//     //   }
//     // }
//
//     lastIndex += loadingNum;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     return Center(
//       child: FutureBuilder(
//         future: getListItemsAndSetLastIndex(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           }
//           if (snapshot.hasError) {
//             return Text('${snapshot.stackTrace}');
//           }
//           return InfinityListView(
//             items: cardMasterModelList,
//             myCardContainList: myCardContainList,
//             imgUrlList: imgUrlList,
//             favoriteList: favoriteList,
//             itemsMaxIndex: cardMasterNum,
//             getListItems: getListItemsAndSetLastIndex,
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }


// class AllCardListPerPrefecture extends ConsumerStatefulWidget {
//   const AllCardListPerPrefecture({Key? key}) : super(key: key);
//
//   @override
//   AllCardsListPerPrefectureState createState() => AllCardsListPerPrefectureState();
// }
//
// class AllCardsListPerPrefectureState extends ConsumerState<AllCardListPerPrefecture> with AutomaticKeepAliveClientMixin{
//   List<CardMasterModel> cardMasterModelList = [];
//   List<bool> myCardContainList = [];
//   List<String?> imgUrlList = [];
//   List<bool?> favoriteList = [];
//   int lastIndex = 0;
//
//   Future<void> getListItemsAndSetLastIndex() async {
//     await getScrollItemList(
//       context,
//       ref,
//       cardMasterModelList,
//       myCardContainList,
//       imgUrlList,
//       favoriteList,
//     );
//   //   int tabIndex = DefaultTabController.of(context).index;
//   //   await Future.delayed(const Duration(seconds: 1));
//   //
//   //   List<CardMasterModel> newCardMasterModelList = await CardMasterRepository().getLimitCountCardMasters(ref, tabIndex);
//   //   for (CardMasterModel model in newCardMasterModelList) {
//   //     cardMasterModelList.add(model);
//   //   }
//   //
//   //   final myCardInfoList = ref.read(myCardInfoListProvider);
//   //   // final myCardSerialNumberList = ref.read(myCardNumberListProvider);
//   //   final myCardSerialNumberList = ["02-201-A001", "02-202-A001", "02-205-A001", "03-202-B001", "01-100-A001", "00-101-A001", "01-100-B001"];
//   //
//   //   // マイカードに含まれているかどうかのリスト
//   //   List<bool> newMyCardContainList = [];
//   //   for (CardMasterModel cardMasterModel in newCardMasterModelList) {
//   //     final myCardContain = myCardSerialNumberList.contains(cardMasterModel.serialNumber);
//   //     newMyCardContainList.add(myCardContain);
//   //   }
//   //   for (bool myCardContain in newMyCardContainList) {
//   //     myCardContainList.add(myCardContain);
//   //   }
//   //
//   //
//   //   final uid = ref.read(authViewModelProvider.notifier).getUid();
//   //   int i = 0;
//   //   /// ListのforEachでasync, awaitを使用するときはFuture.forEachじゃないと処理順番が期待通りにならない
//   //   await Future.forEach(newCardMasterModelList, (item) async {
//   //     if (newMyCardContainList[i]) {
//   //       CardModel? cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${newCardMasterModelList[i].serialNumber}");
//   //       if (cardModel != null && cardModel.photos!.isNotEmpty) {
//   //         final photoFirstDocRef = cardModel.photos![0] as DocumentReference<Map<String, dynamic>>;
//   //         final photoModel = await PhotoRepository().getFromFireStore(photoFirstDocRef);
//   //         if (photoModel != null) {
//   //           final imgUrl = await ImageRepository().downloadOneImageFromFireStore(newCardMasterModelList[i].serialNumber, photoModel.fileName!, ref);
//   //           imgUrlList.add(imgUrl);
//   //         } else {
//   //           imgUrlList.add(null);
//   //         }
//   //       } else {
//   //         imgUrlList.add(null);
//   //       }
//   //     } else {
//   //       imgUrlList.add(null);
//   //     }
//   //     i++;
//   //   });
//   //
//   //   for (CardMasterModel cardMasterModel in newCardMasterModelList) {
//   //     if (myCardSerialNumberList.contains(cardMasterModel.serialNumber)) {
//   //       int index = myCardInfoList.indexWhere((element) => element["id"] == cardMasterModel.serialNumber);
//   //       // newMyFavoriteList.add(myCardInfoList[index]["favorite"]);
//   //       favoriteList.add(false);
//   //     } else {
//   //       favoriteList.add(null);
//   //     }
//   //   }
//
//     lastIndex += loadingNum;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     final selectedPrefecture = ref.read(allCardsPagePrefectureProvider);  // 選択された都道府県
//     final itemsMaxIndex = cardMasterOptionStrList[addressList.indexOf(selectedPrefecture)].length;
//
//     return Center(
//       child: FutureBuilder(
//         future: getListItemsAndSetLastIndex(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           }
//           if (snapshot.hasError) {
//             return Text('${snapshot.stackTrace}');
//           }
//
//           return Column(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     WhiteButton(
//                       text: '都道府県の選択',
//                       fontSize: 16,
//                       onPressed: () async {
//                         int tabIndex = DefaultTabController.of(context).index;
//
//                         // 都道府県の選択のためのModalBottomSheetを出す
//                         await showWhiteModalBottomSheet(
//                           context: context,
//                           widget: AccordionPrefectures(
//                             provider: allCardsPagePrefectureProvider,
//                           )
//                         );
//                         // リストを初期化
//                         cardMasterModelList = [];
//                         myCardContainList = [];
//                         imgUrlList = [];
//                         favoriteList = [];
//                         // FireStoreから取得していたリストのlastDocumentを初期化
//                         ref.read(allCardsListLastDocumentProvider.notifier).state[tabIndex] = null;
//                         // リストのインデックスを初期化
//                         lastIndex = 0;
//                         // 再ビルド
//                         setState(() {});
//                       },
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(left: 10),
//                       width: double.infinity,
//                       child: Text(selectedPrefecture, style: const TextStyle(fontSize: 18)),
//                     ),
//                     Expanded(
//                       child: InfinityListView(
//                         items: cardMasterModelList,
//                         myCardContainList: myCardContainList,
//                         imgUrlList: imgUrlList,
//                         favoriteList: favoriteList,
//                         itemsMaxIndex: itemsMaxIndex,
//                         getListItems: getListItemsAndSetLastIndex,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

// // スクロール可能なListView
// class InfinityListView extends ConsumerStatefulWidget {
//   final List<CardMasterModel> items;    // 一覧画面に表示するカードのリスト
//   final List<bool> myCardContainList;   // マイカードに登録しているか否かのリスト
//   final List<String?> imgUrlList;       // マイカードに登録した画像のURLリスト（マイカードに登録していなければnull）
//   final List<bool?> favoriteList;       // お気に入りカードリスト（マイカードに登録していなければnull）
//   final int itemsMaxIndex;              // リストの最大インデックス番号（全国タブ：全カード数、都道府県タブ：各都道府県のカード数）
//   final Future<void> Function() getListItems;   // リスト追加のメソッド
//
//   const InfinityListView({
//     Key? key,
//     required this.items,
//     required this.myCardContainList,
//     required this.imgUrlList,
//     required this.favoriteList,
//     required this.itemsMaxIndex,
//     required this.getListItems,
//   }) : super(key: key);
//
//   @override
//   InfinityListViewState createState() => InfinityListViewState();
// }

// class InfinityListViewState extends ConsumerState<InfinityListView> {
//
//   // ScrollControllerを用いて、スクロールが終端に行ったことを検知
//   late ScrollController _scrollController;
//   // データ取得中に再度データ取得処理が走らないよう管理
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     // スクロール状態を監視するリスナーを登録
//     _scrollController.addListener(() async {
//       // 現在のスクロール位置が、最大スクロールの0.95の位置を超えた、かつ読み込み中でない時
//       // 全データ（全国タブ：全カード、都道府県タブ：各都道府県の全カード）を取得したら実行しない
//       if (
//       widget.favoriteList.length != widget.itemsMaxIndex
//           && _scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent * 0.95
//           && !_isLoading
//       ) {
//         _isLoading = true;
//
//         await widget.getListItems();
//
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ListView.separated(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       controller: _scrollController,
//       itemCount: widget.favoriteList.length + 1,  // データ長+1、一番最後にデータ取得が終わるfavoriteListの個数に設定
//       separatorBuilder: (BuildContext context, int index) => const SizedBox(
//         height: 2,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         // すべてアイテムを取得した場合は、終端はなにも表示しない
//         if (index < widget.itemsMaxIndex) {
//           // リストが終端に行った際に、現在読み込んでるデータ+1番目の要素として、インジケーターを表示
//           // 一番最後にデータ取得が終わるfavoriteListの読み込みが終わるまで
//           if (widget.favoriteList.length == index) {
//             return const SizedBox(
//               height: 50,
//               width: 50,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               CardShortInfoContainer(
//                 imageUrl: widget.imgUrlList[index],
//                 prefecture: widget.items[index].prefecture,
//                 city: widget.items[index].city,
//                 version: widget.items[index].version,
//                 serialNumber: widget.items[index].serialNumber,
//                 favorite: widget.favoriteList[index],
//               ),
//             ],
//           );
//         } else {
//           return nil;
//         }
//       },
//     );
//   }
// }