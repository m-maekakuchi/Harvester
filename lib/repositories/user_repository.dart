
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_info_model.dart';
import '../viewModels/auth_view_model.dart';

class UserRepository {

  Future<void> getFromFireStore() async {
    // final userUid = _ref.watch(authViewModelProvider.notifier).getUid();
    // final docRef = FirebaseFirestore.instance.collection("users").doc(userUid);
    // docRef.get().then(
    //   (DocumentSnapshot doc) {
    //   print(doc.data());
    //   // final data = doc.data() as Map<String, dynamic>;
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
    // return ;
  }

  Future<void> setToFireStore(UserInfoModel userModel) async {
    final db = FirebaseFirestore.instance;
    final docRef = db
      .collection("users")
      .withConverter(
        fromFirestore: UserInfoModel.fromFirestore,
        toFirestore: (UserInfoModel userModel, options) => userModel.toFirestore(),
      )
      .doc(userModel.firebaseAuthUid);
    await docRef.set(userModel);
  }
}