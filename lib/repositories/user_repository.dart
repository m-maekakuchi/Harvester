import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user_info_model.dart';

class UserRepository {
  final db = FirebaseFirestore.instance;

  // マイカード以外のユーザー情報を取得
  Future<UserInfoModel?> getUserInfoFromFireStore(String userUid) async {
    final UserInfoModel? userInfoModel;

    final ref = db
      .collection("users")
      .doc(userUid);
    final docSnap = await ref.get();
    final user = docSnap.data();

    if (user != null) {
      userInfoModel = UserInfoModel(
        firebaseAuthUid: user['firebase_auth_uid'],
        name: user['name'],
        addressIndex: user['address_index'],
        birthday: user['birthday'].toDate(),
      );
    } else {
      print("No such document.");
      userInfoModel = null;
    }
    return userInfoModel;
  }

  // マイカード情報のみを取得
  Future<UserInfoModel?> getOnlyCardsFromFireStore(String userUid) async {
    final ref = db
        .collection("users")
        .doc(userUid);
    final docSnap = await ref.get();
    final user = docSnap.data();

    UserInfoModel? userInfoModel;
    if (user != null) {
      List? list = user['cards'];
      List<DocumentReference<Map<String, dynamic>>> docRefList = [];
      if (list != null && list.isNotEmpty) {
        for(DocumentReference<Map<String, dynamic>> docRef in list) {
          docRefList.add(docRef);
        }
      }
      userInfoModel = UserInfoModel(
        firebaseAuthUid: user['firebase_auth_uid'],
        cards: docRefList.isEmpty ? null : docRefList,
      );
    } else {
      print("No such document.");
      userInfoModel = null;
    }
    return userInfoModel;
  }

  Future<void> setToFireStore(UserInfoModel userInfoModel) async {
    final docRef = db
      .collection("users")
      .withConverter(
        fromFirestore: UserInfoModel.fromFirestore,
        toFirestore: (UserInfoModel userInfoModel, options) => userInfoModel.toFirestore(),
      )
      .doc(userInfoModel.firebaseAuthUid);
    try {
      await docRef.set(userInfoModel);
    } on Exception {
      debugPrint("*****usersコレクションへのユーザー情報の登録が失敗しました*****");
      rethrow;
    }
  }

  Future<void> deleteFromFireStore(String userUid,  Transaction transaction) async {
    final docRef = db
      .collection("users")
      .withConverter(
        fromFirestore: UserInfoModel.fromFirestore,
        toFirestore: (UserInfoModel userInfoModel, options) => userInfoModel.toFirestore(),
      )
      .doc(userUid);
    try {
      transaction.delete(docRef);
    } on Exception {
      debugPrint("*****usersコレクションのユーザー情報の削除に失敗しました*****");
      rethrow;
    }
  }

  // 値が変わらないフィールドは更新されない
  Future<void> updateProfileFireStore(UserInfoModel userInfoModel) async {
    final washingtonRef = db
      .collection("users")
      .doc(userInfoModel.firebaseAuthUid);
    try {
      await washingtonRef.update(userInfoModel.toFirestore());
    } on Exception {
      debugPrint("*****usersコレクションのユーザー情報の更新に失敗しました*****");
      rethrow;
    }
  }

  // cardsフィールドにカードを追加
  Future<void> updateCardsFireStore(UserInfoModel userInfoModel, Transaction transaction) async {
    final collectionRef = db
      .collection("users");
    final docRef = collectionRef.doc(userInfoModel.firebaseAuthUid);

    try {
      // throw FirebaseException(plugin: "");
      transaction.update(docRef, {
        "cards": FieldValue.arrayUnion(userInfoModel.cards!),
      });
    } on FirebaseException {
      debugPrint("*****usersコレクションのドキュメント内のcardsフィールドの更新に失敗しました*****");
      rethrow;
    }
  }

  Future<void> removeElementOfCards(String uid, DocumentReference removeDocRef, Transaction transaction) async {
    final docRef = db
      .collection("users")
      .doc(uid);

    transaction.update(docRef, {
      "cards": FieldValue.arrayRemove([removeDocRef]),
    });
  }
}