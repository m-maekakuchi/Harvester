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

  Future<void> getOnlyCardsFromFireStore(String userUid) async {
    final userInfoModel = await repository.getOnlyCardsFromFireStore(userUid);
    if (userInfoModel != null) state = userInfoModel;
  }

  Future<void> setToFireStore() async {
    await repository.setToFireStore(state);
  }

  Future<void> updateProfileFireStore() async {
    await repository.updateProfileFireStore(state);
  }

  Future<void> updateCardsFireStore(Transaction transaction) async {
    await repository.updateCardsFireStore(state, transaction);
  }
}