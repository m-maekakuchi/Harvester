import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends StateNotifier<FirebaseAuth>{
  // 初期値
  AuthViewModel() : super(FirebaseAuth.instance);



  Future<void> signInWithTel(String verificationId, String smsCode) async{
    await AuthRepository().signInWithTel(state, verificationId, smsCode);
  }

  Future<void> signInWithGoogle() async{
    await AuthRepository().signInWithGoogle();
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, FirebaseAuth>((ref) {
  return AuthViewModel();
});