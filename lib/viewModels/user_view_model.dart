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

  Future<void> getFromFireStore(String userUid) async {
    print(state.name);

    // await repository.getFromFireStore();
  }

  Future<void> setToFireStore() async {
    await repository.setToFireStore(state);
  }
}