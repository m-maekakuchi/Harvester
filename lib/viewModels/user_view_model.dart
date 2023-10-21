import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_info_model.dart';
import '../repositories/user_repository.dart';

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserInfoModel>
  ((ref) => UserViewModel());

class UserViewModel extends StateNotifier<UserInfoModel> {
  UserViewModel() : super(UserInfoModel());

  UserRepository repository = UserRepository();

  Future<void> setState(UserInfoModel model) async {
    state = model;
  }

  Future<void> getOnlyInfoFromFireStore(String userUid) async {
    final userInfoModel = await repository.getUserInfoFromFireStore(userUid);
    if (userInfoModel != null) state = userInfoModel;
  }

  Future<void> setToFireStore() async {
    try {
      await repository.setToFireStore(state);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFromFireStore(String userUid, Transaction transaction) async {
    try {
      await repository.deleteFromFireStore(userUid, transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfileFireStore() async {
    try {
      await repository.updateProfileFireStore(state);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCardsFireStore(Transaction transaction) async {
    try {
      await repository.updateCardsFireStore(state, transaction);
    } catch (e) {
      rethrow;
    }
  }
}