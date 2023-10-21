import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/app_const.dart';
import '../models/card_master_model.dart';
import '../models/card_model.dart';
import '../provider/providers.dart';
import '../repositories/card_master_repository.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/photo_repository.dart';
import '../viewModels/auth_view_model.dart';

//  全カード一覧画面のスクロールアイテムを取得するメソッド
Future<void> getAllCardsPageScrollItemList(
  BuildContext context,
  WidgetRef ref,
  List<CardMasterModel> cardMasterModelList,
  List<bool> myCardContainList,
  List<String?> imgUrlList,
  List<bool?> favoriteList,
) async {
  final myCardIdAndFavoriteList = ref.read(myCardIdAndFavoriteListProvider);   // マイカード情報リスト（例： [{"id": "00-101-A001", "favorite": true}]）
  final myCardNumberList = ref.read(myCardNumberListProvider);  // マイカードの番号リスト
  final uid = ref.read(authViewModelProvider.notifier).getUid();
  int tabIndex = DefaultTabController.of(context).index;

  // 設定したローディング数分のマスターカードを取得してリストにセット（都道府県タブ選択中であれば、選択された都道府県で絞る）
  List<CardMasterModel> newCardMasterModelList = await CardMasterRepository().getLimitCountCardMasters(ref, tabIndex);
  for (CardMasterModel model in newCardMasterModelList) {
    cardMasterModelList.add(model);
  }

  // 取得したマスターカードが、マイカードに含まれているかどうかを判定し、リストにセット
  List<bool> newMyCardContainList = [];
  for (CardMasterModel cardMasterModel in newCardMasterModelList) {
    final myCardContain = myCardNumberList.contains(cardMasterModel.serialNumber);
    newMyCardContainList.add(myCardContain);
  }
  for (bool myCardContain in newMyCardContainList) {
    myCardContainList.add(myCardContain);
  }

  // 取得したマスターカードがマイカードに含まれていた場合、一番最初に登録されている画像URLを取得し、リストにセット（マイカードになければnull）
  int i = 0;
  /// ListのforEachでasync, awaitを使用するときはFuture.forEachじゃないと処理順番が期待通りにならない
  await Future.forEach(newCardMasterModelList, (item) async {
    // マイカードに含まれているか
    if (newMyCardContainList[i]) {
      CardModel? cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${newCardMasterModelList[i].serialNumber}");
      // マイカードが取得できて、photoフィールドが空ではないとき
      if (cardModel != null && cardModel.photos!.isNotEmpty) {
        // 登録されている画像の1つ目を取得
        final photoFirstDocRef = cardModel.photos![0] as DocumentReference<Map<String, dynamic>>;
        final photoModel = await PhotoRepository().getFromFireStore(photoFirstDocRef);
        // 画像が取得できたら
        if (photoModel != null) {
          // 画像URLを取得
          final imgUrl = await ImageRepository().downloadOneImageFromStorage(newCardMasterModelList[i].serialNumber, photoModel.fileName!, ref);
          imgUrlList.add(imgUrl);
        } else {
          imgUrlList.add(null);
        }
      } else {
        imgUrlList.add(null);
      }
    } else {
      // マイカードに登録されていない場合はGitHubにアップした画像URLを追加
      imgUrlList.add('https://github.com/m-maekakuchi/Harvester-images/blob/main/${newCardMasterModelList[i].serialNumber}.jpg?raw=true');
    }
    i++;
  });

  // 取得したマスターカードがマイカードに含まれていた場合、お気に入りされているかどうかを取得してリストにセット（マイカードになければnull）
  for (CardMasterModel cardMasterModel in newCardMasterModelList) {
    if (myCardNumberList.contains(cardMasterModel.serialNumber)) {
      // ローカルのマイカード情報は追加した順で登録されているので、インデックス検索する
      int index = myCardIdAndFavoriteList.indexWhere((element) => element["id"] == cardMasterModel.serialNumber);
      favoriteList.add(myCardIdAndFavoriteList[index]["favorite"]);
    } else {
      favoriteList.add(null);
    }
  }

}

//  マイカード一覧画面のスクロールアイテムを取得するメソッド
Future<void> getMyCardsPageScrollItemListAndSetIndex (
  int tabIndex,
  WidgetRef ref,
  List<String> sortedMyCardNumberList,
  List<CardMasterModel> cardMasterModelList,
  List<bool> myCardContainList,
  List<String?> imgUrlList,
  List<bool?> favoriteList,
) async {
  final uid = ref.read(authViewModelProvider.notifier).getUid();

  //  ローディング数の設定
  int myCardLoadingNum;
  final firstIndex = ref.read(myCardsPageFirstIndexProvider)[tabIndex];
  final restNum = sortedMyCardNumberList.length - firstIndex; // 残りの個数
  // 残りのアイテムがloadingNumより小さければ、残りの個数をローディング数にする
  if (restNum > loadingMyCardsNum) {
    myCardLoadingNum = loadingMyCardsNum;
  } else {
    myCardLoadingNum = restNum;
  }

  for (int i = firstIndex; i < firstIndex + myCardLoadingNum; i++) {
    final cardMasterModel = await CardMasterRepository().getOneCardMasterUsingDocName(sortedMyCardNumberList[i]);
    cardMasterModelList.add(cardMasterModel!);

    // マイカードに一番最初に登録されている画像URLを取得し、リストに追加（取得に失敗したらnull）
    final cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${sortedMyCardNumberList[i]}");
    if (cardModel != null && cardModel.photos!.isNotEmpty) {
      // 登録されている画像の1つ目を取得
      final photoFirstDocRef = cardModel.photos![0] as DocumentReference<Map<String, dynamic>>;
      final photoModel = await PhotoRepository().getFromFireStore(photoFirstDocRef);
      // 画像が取得できたら
      if (photoModel != null) {
        // 画像URLを取得
        final imgUrl = await ImageRepository().downloadOneImageFromStorage(sortedMyCardNumberList[i], photoModel.fileName!, ref);
        imgUrlList.add(imgUrl);
      } else {
        imgUrlList.add(null);
      }
    } else {
      imgUrlList.add(null);
    }

    //  カードモデルが取得できていたらお気に入り登録の有無を取得してリストに追加
    if (cardModel != null) {
      favoriteList.add(cardModel.favorite);
    } else {
      favoriteList.add(null);
    }

    // マイカード一覧なので、trueを追加
    myCardContainList.add(true);
  }

  ref.read(myCardsPageFirstIndexProvider.notifier).state[tabIndex] += myCardLoadingNum;
}