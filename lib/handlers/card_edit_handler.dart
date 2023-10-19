import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../models/card_model.dart';
import '../models/image_model.dart';
import '../provider/providers.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../repositories/user_repository.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/image_view_model.dart';
import 'convert_data_type_handler.dart';

class CardEdit {
  final Ref ref;
  CardEdit(this.ref);

  Future<void> update(
    CardMasterModel cardMasterModel,
    CardModel cardModel,
    List<ImageModel> preImageModelList  // Storageから画像を削除した後にFireStoreの処理でエラーが発生した場合に備えて、元のimageModelを格納
  ) async {
    final notifier = ref.read(cardEditStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    final uid = ref.read(authViewModelProvider.notifier).getUid();
    final selectedCollectDay = ref.read(cardEditPageCollectDayProvider);
    final selectedFavorite = ref.read(cardEditPageFavoriteProvider);

    // ローカルに登録しているマイカード番号リストの中で、更新対象のカードのインデックスを探す
    final localMyCardNumberList = ref.read(myCardNumberListProvider);
    int updateCardsIndex = 0;
    localMyCardNumberList.asMap().forEach((index, value) {
      if (cardMasterModel.serialNumber == value) {
        updateCardsIndex = index;
      }
    });

    try {
      // Storageに登録されていた画像をすべて削除してから新しい画像を登録
      await ImageRepository().deleteDirectoryFromStorage("$uid/${cardMasterModel.serialNumber}");

      final imageModelList = ref.read(imageListProvider);
      // imageListProviderの各imageModelのfilePathを設定
      for (ImageModel model in imageModelList) {
        model.filePath = "$uid/${cardMasterModel.serialNumber}";
      }
      await ref.read(imageListProvider.notifier).uploadImageToStorage();
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
      return;
    }

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // FireStoreに登録されていたphotosコレクションのドキュメントをすべて削除してから、新しいphotoModelを登録
      List<DocumentReference> photoDocRefs = cardModel.photos!;
      await PhotoRepository().deleteDocument(photoDocRefs, transaction);

      final photoModelList = convertListData(ref.read(imageListProvider), uid);
      List<DocumentReference> photoDocRefList = await PhotoRepository().setToFireStore(photoModelList, transaction);

      final updateCardModel = CardModel(
        cardMaster: cardModel.cardMaster,
        photos: photoDocRefList,
        favorite: selectedFavorite,
        collectDay: selectedCollectDay,
        createdAt: cardModel.createdAt,
        updatedAt: DateTime.now(),
      );
      // cardsコレクションのマイカードを更新
      final cardDocRef = await CardRepository().setToFireStore(updateCardModel, "$uid${cardMasterModel.serialNumber}", transaction);

      // ローカルのマイカード情報を変更
      final List<Map<String, dynamic>> myCardIdAndFavoriteList = [];
      myCardIdAndFavoriteList.addAll(ref.read(myCardIdAndFavoriteListProvider));
      myCardIdAndFavoriteList[updateCardsIndex]["favorite"] = selectedFavorite;
      await LocalStorageRepository().putMyCardIdAndFavorites(myCardIdAndFavoriteList);
    }).then(
      (value) async {
        notifier.state = const AsyncValue.data(null);
        debugPrint("マイカードの更新に必要な処理が全て成功しました");
      },
      onError: (err, stackTrace) async {
        notifier.state = AsyncValue.error(err, stackTrace);
        // FireStoreの更新が失敗したら、Storageに元の画像を登録する（元に戻す）
        await ImageRepository().deleteDirectoryFromStorage("$uid/${cardMasterModel.serialNumber}");
        await ImageRepository().uploadImageToStorage(preImageModelList);
        print(err);
        print(stackTrace);
      },
    );
  }

  Future<void> remove(
    CardMasterModel cardMasterModel,
    List<ImageModel> preImageModelList  // Storageから画像を削除した後にFireStoreの処理でエラーが発生した場合に備えて、元のimageModelを格納
  ) async {
    final notifier = ref.read(cardEditStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    final uid = ref.read(authViewModelProvider.notifier).getUid();
    // ローカルに登録しているマイカード番号リストの中で、削除対象のカードのインデックスを探す
    final localMyCardNumberList = ref.read(myCardNumberListProvider);
    int deleteCardsIndex = 0;
    localMyCardNumberList.asMap().forEach((index, value) {
      if (cardMasterModel.serialNumber == value) {
        deleteCardsIndex = index;
      }
    });

    // storageから画像を削除
    try {
      await ImageRepository().deleteDirectoryFromStorage("$uid/${cardMasterModel.serialNumber}");
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
      return;
    }

    // トランザクションで、FireStoreにマイカード削除を管理
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // FireStoreの３つのコレクションのドキュメント削除を並列処理する
      await Future.wait([
        // photoコレクションの該当ドキュメントを削除
        CardRepository().getDocument("$uid${cardMasterModel.serialNumber}").then((card) async {
          if (card != null) {
            List<DocumentReference> photoDocList = [];
            for (DocumentReference docRef in card["photos"]) {
              photoDocList.add(docRef);
            }
            await PhotoRepository().deleteDocument(photoDocList, transaction);
          }
        }),
        // cardsコレクションの該当ドキュメントを削除
        CardRepository().deleteDocument("$uid${cardMasterModel.serialNumber}", transaction),
        // usersコレクションのcardsフィールドの該当インデックスを削除
        UserRepository().getCardsFieldReferenceFromFireStore(uid, deleteCardsIndex).then((cardField) async {
          UserRepository().removeElementOfCards(uid, cardField, transaction);
        }),
      ]);

      // ローカルのマイカード情報を変更
      final List<Map<String, dynamic>> myCardIdAndFavoriteList = [];
      myCardIdAndFavoriteList.addAll(ref.read(myCardIdAndFavoriteListProvider));
      myCardIdAndFavoriteList.removeAt(deleteCardsIndex);
      await LocalStorageRepository().putMyCardIdAndFavorites(myCardIdAndFavoriteList);
    }).then(
      (value) async {
        notifier.state = const AsyncValue.data(null);
        debugPrint("マイカードの削除に必要な処理が全て成功しました");
      },
      onError: (err, stackTrace) async {
        // FireStoreの処理が失敗したら、Storageの元の画像を登録する（元に戻す）
        await ImageRepository().uploadImageToStorage(preImageModelList);
        notifier.state = AsyncValue.error(err, stackTrace);
        print(err);
        print(stackTrace);
      },
    );
  }
}