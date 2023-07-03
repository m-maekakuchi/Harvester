
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_info_model.dart';

class UserRepository {
  final db = FirebaseFirestore.instance;

  Future<UserInfoModel?> getFromFireStore(String userUid) async {
    final ref = db
      .collection("users")
      .doc(userUid)
      .withConverter(
        fromFirestore: UserInfoModel.fromFirestore,
        toFirestore: (UserInfoModel userInfoModel, _) => userInfoModel.toFirestore(),
      );
    final docSnap = await ref.get();
    final userInfoModel = docSnap.data();
    if (userInfoModel != null) {
      return userInfoModel;
    } else {
      print("No such document.");
      return null;
    }
  }

  Future<void> setToFireStore(UserInfoModel userInfoModel) async {
    final docRef = db
      .collection("users")
      .withConverter(
        fromFirestore: UserInfoModel.fromFirestore,
        toFirestore: (UserInfoModel userInfoModel, options) => userInfoModel.toFirestore(),
      )
      .doc(userInfoModel.firebaseAuthUid);
    await docRef.set(userInfoModel).then(
      (value) => print("DocumentSnapshot successfully set!"),
      onError: (e) => print("Error setting document $e")
    );
  }

  // 値が変わらないフィールドは更新されない
  Future<void> updateProfileFireStore(UserInfoModel userInfoModel) async {
    final washingtonRef = db
      .collection("users")
      .doc(userInfoModel.firebaseAuthUid);
    await washingtonRef.update(userInfoModel.toFirestore()).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e")
    );
  }

  Future<void> updateCardsFireStore(UserInfoModel userInfoModel) async {
    final washingtonRef = db
      .collection("users")
      .doc(userInfoModel.firebaseAuthUid);

    await washingtonRef.update({
      "cards": FieldValue.arrayUnion(userInfoModel.cards!),
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e")
    );
  }
}