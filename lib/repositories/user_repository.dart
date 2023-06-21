
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../viewModels/auth_view_model.dart';

class UserRepository {

  // Future<void> getUserFromFirebase() async {
  //   final userUid = _ref.watch(authViewModelProvider.notifier).getUid();
  //   final docRef = FirebaseFirestore.instance.collection("users").doc(userUid);
  //   docRef.get().then(
  //     (DocumentSnapshot doc) {
  //     print(doc.data());
  //     // final data = doc.data() as Map<String, dynamic>;
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  //   // return ;
  // }

  Future<void> setUserToFirebase(UserModel userModel) async {
    print("aaaaaaaa");
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection("users")
        .withConverter(
      fromFirestore: UserModel.fromFirestore,
      toFirestore: (UserModel userModel, options) => userModel.toFirestore(),
    )
        .doc(userModel.firebaseAuthUid);
    await docRef.set(userModel);
  }
}