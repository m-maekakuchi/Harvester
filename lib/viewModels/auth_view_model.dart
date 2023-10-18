import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>(
    (ref) => AuthViewModel(ref)..appStarted(),
);

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  StreamSubscription<User?>? _idTokenChangesSubscription;

  AuthViewModel(this._ref) : super(const AsyncValue.loading()) {
    _idTokenChangesSubscription?.cancel();
    _idTokenChangesSubscription = _ref.read(authRepositoryProvider).idTokenChanges.listen((user) async {
      state = AsyncValue.data(user);
    });
  }

  @override
  void dispose() {
    _idTokenChangesSubscription?.cancel();
    super.dispose();
  }

  void appStarted() async {
    _ref.read(authRepositoryProvider).getCurrentUser();
  }

  User? getCurrentUser() {
    return _ref.read(authRepositoryProvider).getCurrentUser();
  }

  bool isSignIn() {
    return _ref.read(authRepositoryProvider).isSignIn();
  }

  String getUid() {
    return _ref.read(authRepositoryProvider).getCurrentUser()!.uid;
  }

  Future<void> reload() async {
    await _ref.read(authRepositoryProvider).getCurrentUser()!.reload();
  }

  Future<void> verifyPhoneNumberNative(String phoneNumber, BuildContext context) async {
    await _ref.read(authRepositoryProvider).verifyPhoneNumberNative(phoneNumber, context);
  }

  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    await _ref.read(firebaseAuthProvider).signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }

  Future<void> delete() async {
    await _ref.read(authRepositoryProvider).delete();
  }

  Future<void> signInWithTel(String verificationId, String smsCode) async{
    // await _ref.read(authRepositoryProvider).signInWithTel(state, verificationId, smsCode);
  }

  Future<void> signInWithGoogle() async{
    // await AuthRepository().signInWithGoogle();
  }

  Future<void> registerCustomStatus() async {
    try {
      await _ref.read(authRepositoryProvider).registerCustomStatus();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerColorIndex(int index) async {
    await _ref.read(authRepositoryProvider).registerColorIndex(index);
  }

  // Future<void> removeCustomStatus() async {
  //   await _ref.read(authRepositoryProvider).removeCustomStatus();
  // }
}