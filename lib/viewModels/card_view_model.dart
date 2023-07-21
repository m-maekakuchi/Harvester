import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/models/photo_model.dart';

import '../commons/message.dart';
import '../handlers/card_master_handler.dart';
import '../handlers/convert_data_type_handler.dart';
import '../models/card_model.dart';
import '../models/image_model.dart';
import '../models/user_info_model.dart';
import '../repositories/card_master_repository.dart';
import '../repositories/card_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../views/widgets/error_message_dialog.dart';
import '../views/pages/collections/my_card_add_page.dart';
import 'auth_view_model.dart';
import 'image_view_model.dart';
import 'user_view_model.dart';

final cardViewModelProvider = StateNotifierProvider<CardViewModel, AsyncValue<bool>>((ref) {
  return CardViewModel();
});

class CardViewModel extends StateNotifier<AsyncValue<bool>> {

  CardViewModel() : super(const AsyncValue.data(false));  // カード追加処理が全て完了したらdataをtrueにする

  Future<void> cardAdd(
    String selectedCard,
    List<ImageModel> selectedImageList,
    DateTime selectedDay,
    bool favorite,
    WidgetRef ref,
    BuildContext context
  ) async {

    List<String>? cardNumberList = [];  // ローカルに登録されているカード番号を格納する配列
    List<Map<String, dynamic>>? localMyCardInfoList;  // ローカルに登録されているマイカード情報を格納する配列
    List<PhotoModel> photoModelList = [];
    final uid = ref.watch(authViewModelProvider.notifier).getUid();

    // 選択されたカード番号取得
    RegExp regex = RegExp(r'\s');
    final selectedCardMasterNumber = selectedCard.split(regex)[0];
    //
    /// 例外処理は後でまとめて処理できるようにしたい
    try {
      state = const AsyncValue.loading();

      // throw Exception("エラー発生");

      // Hiveでローカルからマイカードの番号を取得
      localMyCardInfoList = await LocalStorageRepository().fetchMyCardNumber();
      print("***********ローカルのカード情報：$localMyCardInfoList***********");

      // ローカルにデータがない場合FireStoreから取得
      // cardsフィールドがない又はcardsフィールドの配列が空の場合、戻り値はnull
      localMyCardInfoList ??= await getCardMasterNumberList(uid, ref);

      if (localMyCardInfoList != null) {
        for (Map<String, dynamic> localMyCardInfo in localMyCardInfoList) {
          if (localMyCardInfo.isNotEmpty) cardNumberList.add(localMyCardInfo['id']);
        }
      }
      print("***********cardNumberList：$cardNumberList***********");

      // 追加しようとしているカードが既に登録されていたらダイアログで警告
      if (localMyCardInfoList != null
          && cardNumberList.contains(selectedCardMasterNumber)
      ) {
        state = const AsyncValue.data(false);
        if (context.mounted) await errorMessageDialog(context, registeredCardErrorMessage);
        return;
      }

      // imageListProviderの各imageModelのfilePathを設定
      for (ImageModel model in selectedImageList) {
        model.filePath = "$uid/$selectedCardMasterNumber";
      }

      // 画像をstorageに登録
      await ref.read(imageListProvider.notifier).uploadImageToFirebase();

      // photoモデルリストの作成
      photoModelList = convertListData(ref.read(imageListProvider), ref);
    } catch (err, stackTrace) {
      print("***********Error updating document $err***********");
      state = AsyncValue.error(err, stackTrace);
      return;
    }

    // トランザクションでFireStoreにマイカードを登録
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // photosコレクションに登録（戻り値：ドキュメント参照の配列）
      List<DocumentReference> photoDocRefList = await PhotoRepository().setToFireStore(photoModelList, transaction);

      //　選択したマスターカードのドキュメント参照を取得
      final cardMasterDocRef = await CardMasterRepository().getCardMasterRef(selectedCardMasterNumber);
      final now = DateTime.now();
      // cardモデルの作成
      final cardModel = CardModel(
        cardMaster: cardMasterDocRef,
        photos: photoDocRefList,
        favorite: ref.read(bookmarkProvider),
        collectDay: selectedDay,
        createdAt: now,
        updatedAt: now,
      );
      // cardsコレクションに登録（戻り値：ドキュメント参照）
      final cardDocRef = await CardRepository().setToFireStore(cardModel, "$uid$selectedCardMasterNumber", transaction);

      // userモデルの作成
      final userModel = UserInfoModel(
        firebaseAuthUid: uid,
        cards: [cardDocRef],
      );
      await ref.read(userViewModelProvider.notifier).setState(userModel);
      // cardの情報をFireStoreに登録
      await ref.read(userViewModelProvider.notifier).updateCardsFireStore(transaction);
      // throw Exception("エラー発生");
    }).then(
      // トランザクションが成功したとき
      (value) async {
        print("***********MyCard successfully updated!***********");
        // ローカルのマイカード情報にカードを追加
        // cardNumberListがnullだったら初めての登録
        final localMyCardInfo = {
          "id": selectedCardMasterNumber,
          "favorite": favorite
        };
        if (localMyCardInfoList == null) {
          print("***********はじめてのカード追加です 次のデータをローカルに追加 localMyCardInfoList：$localMyCardInfo***********");
          await LocalStorageRepository().putMyCardNumber([localMyCardInfo]);
        } else {
          localMyCardInfoList.add(localMyCardInfo);
          print("***********カード追加2回目以降です 次のリストをローカルに追加 localMyCardInfoList：$localMyCardInfoList***********");
          await LocalStorageRepository().putMyCardNumber(localMyCardInfoList);
        }
        state = const AsyncValue.data(true);
      },
      // トランザクションが失敗したとき
      onError: (err, stackTrace) async {
        print("***********Error updating document $err***********");
        await ref.read(imageListProvider.notifier).deleteImageFromFireStore();
        state = AsyncValue.error(err, stackTrace);
      },
    );
  }
}