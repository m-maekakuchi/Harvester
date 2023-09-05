import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/user_view_model.dart';

class AllUserDataDelete {
  final Ref ref;
  AllUserDataDelete(this.ref);

  // 退会ボタンが押されたときに、ユーザーが登録したデータを全て削除
  Future<void> delete() async {

    final notifier = ref.read(allUserDeleteStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    final uid = ref.read(authViewModelProvider.notifier).getUid();
    final myCardNumberList = ref.read(myCardNumberListProvider);

    // storageから画像を削除
    try {
      Future.forEach(myCardNumberList, (myCardNumber) async {
        await ImageRepository().deleteDirectoryFromFireStore("$uid/$myCardNumber");
      });
    } catch (err, stackTrace) {
      print("***********Error updating document $err***********");
      notifier.state = AsyncValue.error(err, stackTrace);
      return;
    }

    // トランザクションで、FireStoreにマイカード削除を管理
    await FirebaseFirestore.instance.runTransaction((transaction) async {

      await Future.forEach(myCardNumberList, (myCardNumber) async {
        // photoコレクションの該当ドキュメントを削除
        final card = await CardRepository().getDocument("$uid$myCardNumber");
        if (card != null) {
          List<DocumentReference> photoDocList = [];
          for (DocumentReference docRef in card["photos"]) {
            photoDocList.add(docRef);
          }
          await PhotoRepository().deleteDocument(photoDocList, transaction);
        }

        // cardsコレクションの該当ドキュメントを削除
        await CardRepository().deleteDocument("$uid$myCardNumber", transaction);
      });

      // usersコレクションから該当ドキュメントを削除
      await ref.watch(userViewModelProvider.notifier).deleteFromFireStore(uid, transaction);

      // ローカルのマイカード情報を削除
      await LocalStorageRepository().deleteUserInfo();
      await LocalStorageRepository().deleteMyCardIdAndFavorites();

      // throw Exception("エラー発生");
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