import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

final userProvider = StateNotifierProvider<UserViewModel, UserModel>
  ((ref) => UserViewModel());

class UserViewModel extends StateNotifier<UserModel> {
  UserViewModel() : super(UserModel());

  UserRepository repository = UserRepository();

  Future<void> setState(UserModel model) async {
    state = model;
  }

  Future<void> setToFirestore() async {
    if (state.name != "") {
      await repository.setUserToFirebase(state);
    }
  }


}