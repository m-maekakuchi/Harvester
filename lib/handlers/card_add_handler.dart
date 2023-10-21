import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/message.dart';
import 'convert_data_type_handler.dart';
import '../models/card_model.dart';
import '../models/image_model.dart';
import '../models/photo_model.dart';
import '../models/user_info_model.dart';
import '../provider/providers.dart';
import '../repositories/card_master_repository.dart';
import '../repositories/card_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../views/widgets/text_message_dialog.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/image_view_model.dart';
import '../viewModels/user_view_model.dart';

class CardAdd{
  final Ref ref;
  CardAdd(this.ref);

  Future<void> cardAdd(
    BuildContext context
  ) async {
    final notifier = ref.read(cardAddStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    final selectedCard = ref.read(cardAddPageCardProvider);
    final selectedImageList = ref.read(imageListProvider);
    final selectedDay = ref.read(cardAddPageCollectDayProvider);
    final favorite = ref.read(cardAddPageFavoriteProvider);

    List<String> cardNumberList = [];                           // ローカルに登録されているカード番号を格納
    List<Map<String, dynamic>> localMyCardInfoList = [];        // ローカルに登録されているマイカード情報を格納
    List<PhotoModel> photoModelList = [];
    final uid = ref.watch(authViewModelProvider.notifier).getUid();

    cardNumberList.addAll(ref.read(myCardNumberListProvider));
    localMyCardInfoList.addAll(ref.read(myCardIdAndFavoriteListProvider));

    // 選択されたカード番号取得
    RegExp regex = RegExp(r'\s');
    final selectedCardMasterNumber = selectedCard.split(regex)[0];

    debugPrint("*****追加前のローカルに保存されているマイカード番号：$cardNumberList*****");

    // 追加しようとしているカードが既に登録されていたらダイアログで警告
    if (cardNumberList.contains(selectedCardMasterNumber)) {
      notifier.state = const AsyncValue.data(false);
      if (context.mounted) await textMessageDialog(context, registeredCardErrorMessage);
      return;
    }

    // imageListProviderの各imageModelのfilePathを設定
    for (ImageModel model in selectedImageList) {
      model.filePath = "$uid/$selectedCardMasterNumber";
    }

    try {
      // 画像をstorageに登録
      await ref.read(imageListProvider.notifier).uploadImageToStorage();
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
      return;
    }

    // トランザクションでFireStoreにマイカードを登録
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // photoモデルリストの作成
      photoModelList = convertListData(ref.read(imageListProvider), uid);
      // photosコレクションに登録（戻り値：ドキュメント参照の配列）
      List<DocumentReference> photoDocRefList = await PhotoRepository().setToFireStore(photoModelList, transaction);

      //　選択したマスターカードのドキュメント参照を取得
      final cardMasterDocRef = await CardMasterRepository().getCardMasterRef(selectedCardMasterNumber);
      final now = DateTime.now();
      final cardModel = CardModel(
        cardMaster: cardMasterDocRef,
        photos: photoDocRefList,
        favorite: ref.read(cardAddPageFavoriteProvider),
        collectDay: selectedDay,
        createdAt: now,
        updatedAt: now,
      );
      // cardsコレクションに登録（戻り値：ドキュメント参照）
      final cardDocRef = await CardRepository().setToFireStore(cardModel, "$uid$selectedCardMasterNumber", transaction);

      final userModel = UserInfoModel(
        firebaseAuthUid: uid,
        cards: [cardDocRef],
      );
      await ref.read(userViewModelProvider.notifier).setState(userModel);
      // cardの情報をFireStoreに登録
      await ref.read(userViewModelProvider.notifier).updateCardsFireStore(transaction);

      // ローカルのマイカード情報にカードを追加
      final localMyCardInfo = {
        "id": selectedCardMasterNumber,
        "favorite": favorite
      };
      // ローカルのマイカード情報を更新
      localMyCardInfoList.add(localMyCardInfo);
      debugPrint("*****ローカルのデータを次のリストで更新*****\n$localMyCardInfoList");
      await LocalStorageRepository().putMyCardIdAndFavorites(localMyCardInfoList);

      // 登録したカードをプロバイダにも追加
      ref.read(myCardIdAndFavoriteListProvider.notifier).state.add(localMyCardInfo);
      ref.read(myCardNumberListProvider.notifier).state.add(selectedCardMasterNumber);
      debugPrint("*****追加後のローカルに保存されているマイカード番号：${ref.read(myCardNumberListProvider)}*****");
    }).then(
      // トランザクションが成功したとき
      (value) async {
        notifier.state = const AsyncValue.data(true);
        debugPrint("*****FireStoreへの全ての登録とローカルへの登録処理が成功しました*****");
      },
      // トランザクションが失敗したとき
      onError: (err, stackTrace) async {
        await ref.read(imageListProvider.notifier).deleteImageFromStorage();
        notifier.state = AsyncValue.error(err, stackTrace);
        print(err);
        print(stackTrace);
      },
    );
  }
}