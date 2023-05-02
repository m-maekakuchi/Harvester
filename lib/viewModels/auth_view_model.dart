import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/BaseAuthRepository.dart';
import '../repositories/auth_repository.dart';

// final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>(
//       (ref) => AuthViewModel(ref)..appStarted(),
// );

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  StreamSubscription<User?>? _idTokenChangesSubscription;

  AuthViewModel(this._ref) : super(const AsyncValue.loading()) {
    _idTokenChangesSubscription?.cancel();
    _idTokenChangesSubscription = _ref.read(authRepositoryProvider).idTokenChanges.listen((user) async {
      state = AsyncValue.data(user);
    });
  }



  // Future<void> signInWithTel(String verificationId, String smsCode) async{
  //   await AuthRepository().signInWithTel(state, verificationId, smsCode);
  // }
  //
  // Future<void> signInWithGoogle() async{
  //   await AuthRepository().signInWithGoogle();
  // }
}