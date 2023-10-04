import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_info_model.dart';
import '../provider/providers.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/user_view_model.dart';

class UserHandler {
  final Ref ref;
  UserHandler(this.ref);

  Future<void> register(UserInfoModel userInfoModel) async {
    final notifier = ref.read(userEditStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    // await Future.delayed(   // 1秒後にダイアログを閉じる
    //   const Duration(seconds: 5),
    // );

    try {
      // userViewModelProviderの状態を変更してFireStoreに登録する
      ref.watch(userViewModelProvider.notifier).setState(userInfoModel);
      ref.watch(userViewModelProvider.notifier).setToFireStore();

      // Hiveでローカルにユーザー情報を保存
      await LocalStorageRepository().putUserInfo(userInfoModel);

      // ユーザ情報の登録が完了したことをCustom Claimに登録
      await ref.read(authViewModelProvider.notifier).registerCustomStatus();

    } catch(err, stackTrace) {
      print("***********Error registering document $err***********");
      notifier.state = AsyncValue.error(err, stackTrace);
      return;
    }
    notifier.state = const AsyncValue.data(null);
  }

  Future<void> update(UserInfoModel userInfoModel) async {
    final notifier = ref.read(userEditStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    try {
      // 2つの機能を並列処理
      Future.wait([
        // userViewModelProviderの状態を変更してFireStoreを更新する
        ref.watch(userViewModelProvider.notifier).setState(userInfoModel).then((_) async {
          await ref.read(userViewModelProvider.notifier).updateProfileFireStore();
        }),
        // Hiveでローカルにユーザー情報を保存
        LocalStorageRepository().putUserInfo(userInfoModel),
      ]);
      // throw Exception("エラー発生");
    } catch(err, stackTrace) {
      print("***********Error updating document $err***********");
      notifier.state = AsyncValue.error(err, stackTrace);
      return;
    }
    notifier.state = const AsyncValue.data(null);
  }

  // 退会ボタンが押されたときに、ユーザーが登録したデータを全て削除
  Future<void> delete() async {

    final notifier = ref.read(userEditStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    // await Future.delayed(   // 1秒後にダイアログを閉じる
    //   const Duration(seconds: 5),
    // );

    final uid = ref.read(authViewModelProvider.notifier).getUid();
    final myCardNumberList = ref.read(myCardNumberListProvider);

    // storageから画像を削除
    try {
      Future.forEach(myCardNumberList, (myCardNumber) async {
        await ImageRepository().deleteDirectoryFromFireStore("$uid/$myCardNumber");
      });
    } catch (err, stackTrace) {
      print("***********Error deleting document $err***********");
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

      // ローカルの情報を削除
      await LocalStorageRepository().deleteUserInfo();
      await LocalStorageRepository().deleteMyCardIdAndFavorites();

      // throw Exception("エラー発生");
    }).then(
      (value) async {
        notifier.state = const AsyncValue.data(null);
      },
      onError: (err, stackTrace) async {
        print("***********Error deleting document $err***********");
        notifier.state = AsyncValue.error(err, stackTrace);
      },
    );
  }
}