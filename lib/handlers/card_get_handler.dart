import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/card_master_repository.dart';
import '../repositories/card_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/user_repository.dart';
import '../viewModels/auth_view_model.dart';

Future<List<Map<String, dynamic>>?> getMyCardIdAndFavoriteFromLocalOrDB (WidgetRef ref) async {
  List<Map<String, dynamic>>? dbMyCardInfoList;
  try {
    // Hiveでローカルからマイカードの番号を取得
    List<Map<String, dynamic>>? localMyCardInfoList = await LocalStorageRepository().fetchMyCardIdAndFavorites();
    debugPrint("ローカルのマイカード情報：${localMyCardInfoList.toString()}");
    if (localMyCardInfoList != null && localMyCardInfoList.isNotEmpty) return localMyCardInfoList;

    // ローカルに保存されていない又は空の場合、FireStoreから取得
    // cardsフィールドがない又はcardsフィールドの配列が空の場合、戻り値はnull
    final uid = ref.watch(authViewModelProvider.notifier).getUid();
    dbMyCardInfoList = await getMyCardNumberListFromFireStore(uid, ref);
    debugPrint("上がnullの場合DBから取得したあとのマイカード情報：${dbMyCardInfoList.toString()}");

    // DBからデータが取得できたとき、ローカルにマイカード情報の登録がないのにDBにはあるという状況なので、
    // DBから取得した情報をローカルに登録しておく
    if (dbMyCardInfoList != null) {
      await LocalStorageRepository().putMyCardIdAndFavorites(dbMyCardInfoList);
    }
  } catch (e) {
    rethrow;
  }
  return dbMyCardInfoList;
}


// ユーザーが登録済みのマイカード情報のリストを取得
Future<List<Map<String, dynamic>>?> getMyCardNumberListFromFireStore(String uid, WidgetRef ref) async{
  List<Map<String, dynamic>>? cardNumberList;
  try {
    // ユーザーのカード情報を取得
    List<DocumentReference<Map<String, dynamic>>>? cardDocRefList = await UserRepository().getCardReferencesFromFireStore(uid);
    // cardsフィールドが存在し、配列が空ではないとき
    if (cardDocRefList != null && cardDocRefList.isNotEmpty) {
      cardNumberList = [];
      await Future.forEach(cardDocRefList, (docRef) async {
        // カードのドキュメント参照からカードモデルを取得
        final cardModel = await CardRepository().getFromFireStoreUsingDocRef(docRef);
        // cardsコレクションに、ドキュメント参照のドキュメントがちゃんと存在する場合
        if (cardModel != null) {
          final cardMasterDocRef = cardModel.cardMaster as DocumentReference<Map<String, dynamic>>;
          final cardMasterModel = await CardMasterRepository().getCardMasterUsingDocRef(cardMasterDocRef);
          // card_masterコレクションに、ドキュメント参照のドキュメントがちゃんと存在する場合
          if (cardMasterModel != null) {
            cardNumberList!.add(
              {
                "id": cardMasterModel.serialNumber,
                "favorite": cardModel.favorite
              }
            );
          }
        }
      });
    }
    return cardNumberList;
  } on FirebaseException {
    rethrow;
  }
}