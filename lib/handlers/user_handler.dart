import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/message.dart';
import '../models/user_info_model.dart';
import '../provider/providers.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';
import '../repositories/local_storage_repository.dart';
import '../repositories/photo_repository.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/user_view_model.dart';
import '../views/widgets/text_message_dialog.dart';

class UserHandler {
  final Ref ref;
  UserHandler(this.ref);

  Future<void> fetch(BuildContext context) async {
    final notifier = ref.read(userHandlerStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    try {
      // ローカルに保存されたユーザー情報を取得
      var userInfoModel = await LocalStorageRepository().fetchUserInfo();
      // ローカルにユーザー情報が保存されていない場合、Firebaseから取得
      if (userInfoModel == null) {
        final uid = ref.watch(authViewModelProvider.notifier).getUid();
        await ref.read(userViewModelProvider.notifier).getOnlyInfoFromFireStore(uid);
      } else {
        // ローカルにユーザー情報があった場合は、UserViewModelにセット
        await ref.read(userViewModelProvider.notifier).setState(userInfoModel);
      }
      notifier.state = const AsyncValue.data(null);
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
      textMessageDialog(
        context,
        "$undefinedErrorMessage$tryAgainLaterMessage"
      );
    }
  }

  Future<void> register(UserInfoModel userInfoModel) async {
    final notifier = ref.read(userHandlerStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    // await Future.delayed(const Duration(seconds: 5));
    try {
      // userViewModelProviderの状態を変更してFireStoreに登録する
      await ref.watch(userViewModelProvider.notifier).setState(userInfoModel);
      await ref.watch(userViewModelProvider.notifier).setToFireStore();

      // Hiveでローカルにユーザー情報を保存
      await LocalStorageRepository().putUserInfo(userInfoModel);
      
      // ユーザ情報の登録が完了したことをCustom Claimに登録
      await ref.read(authViewModelProvider.notifier).registerCustomStatus();
      debugPrint("*****ユーザー登録処理が全て成功しました*****");
      notifier.state = const AsyncValue.data(null);
    } catch(err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
    }
  }

  Future<void> update(UserInfoModel userInfoModel) async {
    final notifier = ref.read(userHandlerStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    try {
      // userViewModelProviderの状態を変更してFireStoreを更新する
      await ref.watch(userViewModelProvider.notifier).setState(userInfoModel).then((_) async {
        await ref.read(userViewModelProvider.notifier).updateProfileFireStore();
      });
      // Hiveでローカルにユーザー情報を保存
      await LocalStorageRepository().putUserInfo(userInfoModel);

      debugPrint("*****ユーザーの更新処理が全て成功しました*****");
      notifier.state = const AsyncValue.data(null);
    } catch(err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
    }
  }

  Future<void> delete() async {

    final notifier = ref.read(userHandlerStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    // await Future.delayed(const Duration(seconds: 5));

    final uid = ref.read(authViewModelProvider.notifier).getUid();
    final myCardNumberList = ref.read(myCardNumberListProvider);

    // storageから画像を削除
    try {
      await Future.forEach(myCardNumberList, (myCardNumber) async {
        await ImageRepository().deleteDirectoryFromStorage("$uid/$myCardNumber");
      });
      debugPrint("*****ユーザーが登録した全ての画像の削除が成功しました*****");
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
      return;
    }

    // トランザクションで、FireStoreのマイカード関連のデータ削除の管理
    await FirebaseFirestore.instance.runTransaction((transaction) async {

      await Future.forEach(myCardNumberList, (myCardNumber) async {
        // photoコレクションの該当ドキュメントを削除

        await Future.wait([
          // photoコレクションの該当ドキュメントを削除
          CardRepository().getDocument("$uid$myCardNumber").then((card) async {
            if (card != null) {
              List<DocumentReference> photoDocList = [];
              for (DocumentReference docRef in card["photos"]) {
                photoDocList.add(docRef);
              }
              await PhotoRepository().deleteDocument(photoDocList, transaction);
            }
          }),
          // cardsコレクションの該当ドキュメントを削除
          CardRepository().deleteDocument("$uid$myCardNumber", transaction),
        ]);
      });

      // usersコレクションの該当ドキュメントを削除
      await ref.watch(userViewModelProvider.notifier).deleteFromFireStore(uid, transaction);

      // Authenticationのユーザーを削除し、削除されたアカウントのuidをfireStoreに登録する
      final deletedData = {
        "uid": uid,
        "deletedAt": DateTime.now(),
      };
      await FirebaseFirestore.instance.collection('deleted_users').add(deletedData);
    }).then(
      (value) async {
        debugPrint("*****FireStore内の全てのデータを削除し、deleted_usersコレクションへの登録に成功しました*****");
      },
      onError: (err, stackTrace) async {
        notifier.state = AsyncValue.error(err, stackTrace);
        print(err);
        print(stackTrace);
        return;
      },
    );

    try {
      // ローカルの情報を削除
      await LocalStorageRepository().deleteUserInfo();
      await LocalStorageRepository().deleteMyCardIdAndFavorites();

      notifier.state = const AsyncValue.data(null);
      debugPrint("*****退会処理が全て成功しました*****");
    } catch (err, stackTrace) {
      notifier.state = AsyncValue.error(err, stackTrace);
      print(err);
      print(stackTrace);
    }
  }
}