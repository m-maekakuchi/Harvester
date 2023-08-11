import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../provider/providers.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../repositories/user_repository.dart';
import '../viewModels/auth_view_model.dart';

final cardRemoveProvider = Provider((ref) => CardRemove(ref));

class CardRemove {
  final Ref ref;
  CardRemove(this.ref);

  Future<void> cardRemove(CardMasterModel cardMasterModel) async {
    final notifier = ref.read(cardRemoveStateProvider.notifier);
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
      await ImageRepository().deleteDirectoryFromFireStore("$uid/${cardMasterModel.serialNumber}");
    } catch (err, stackTrace) {
      print("***********Error updating document $err***********");
      notifier.state = AsyncValue.error(err, stackTrace);
      return;
    }

    // トランザクションで、FireStoreにマイカード削除を管理
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // photoコレクションの該当ドキュメントを削除
      final card = await CardRepository().getDocument("$uid${cardMasterModel.serialNumber}");
      if (card != null) {
        final photoField = card["photos"];
        await Future.forEach(photoField, (photoDocRef) async {
          await PhotoRepository().deleteDocument(photoDocRef as DocumentReference<Map<String, dynamic>>, transaction);
        });
      }

      // cardsコレクションの該当ドキュメントを削除
      await CardRepository().deleteDocument("$uid${cardMasterModel.serialNumber}", transaction);

      // usersコレクションのcardsフィールドの該当インデックスを削除
      final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final cardField = docSnapshot.data()!["cards"][deleteCardsIndex] as DocumentReference;
      await UserRepository().removeElementOfCards(uid, cardField, transaction);

      // ローカルのマイカード情報を変更
      final List<Map<String, dynamic>> myCardIdAndFavoriteList = [];
      myCardIdAndFavoriteList.addAll(ref.read(myCardIdAndFavoriteListProvider) as List<Map<String, dynamic>>);
      myCardIdAndFavoriteList.removeAt(deleteCardsIndex);
      // throw Exception("エラー発生");
      await LocalStorageRepository().putMyCardIdAndFavorites(myCardIdAndFavoriteList);
    }).then(
      (value) async {
        notifier.state = const AsyncValue.data(null);
      },
      onError: (err, stackTrace) async {
        print("***********Error updating document $err***********");
        notifier.state = AsyncValue.error(err, stackTrace);
      },
    );
  }
}