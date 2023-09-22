import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum FirebaseAuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

abstract class BaseAuthRepository {
  Stream<User?> get idTokenChanges;

  User? getCurrentUser();

  Future<void> revalidation(PhoneAuthCredential credential);

  Future<void> signOut();

  Future<void> delete();
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) => AuthRepository(ref));
final verificationIdRepositoryProvider = StateProvider<String>((ref) => '');
final confirmationResultRepositoryProvider = StateProvider<ConfirmationResult?>((ref) => null);

class AuthRepository implements BaseAuthRepository {
  final Ref _ref;

  AuthRepository(this._ref);

  @override
  Stream<User?> get idTokenChanges => _ref.read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    try {
      return _ref.read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      // throw CustomException(message: e.message);
    }
    return null;
  }

  @override
  Future<void> revalidation(PhoneAuthCredential credential) async {
    User? user = getCurrentUser();
    await user?.reauthenticateWithCredential(credential);
  }

  bool isSignIn() {
    return _ref.read(firebaseAuthProvider).currentUser?.uid != null;
  }

  Future<void> verifyPhoneNumberNative(String phoneNumber,
      BuildContext context) async {
    await _ref.read(firebaseAuthProvider).verifyPhoneNumber(
      phoneNumber: phoneNumber,
      // AndroidデバイスでのSMSコードの自動処理 =====================
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (kDebugMode) {
          print('-------verificationCompleted-------');
        }
        await _ref.read(firebaseAuthProvider).signInWithCredential(credential);
      },
      // 無効な電話番号やSMSクォータを超えたかどうかなどの障害イベントを処理します。 =====================
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print('-------verificationFailed-------${e.code}');
          print(e.message);
        }
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }
      },
      // コードがFirebaseからデバイスに送信されたときに処理し、ユーザーにコードの入力を求めるために使用されます。 =====================
      // firebaseのrobot後に呼ばれる
      codeSent: (String verificationId, int? forceResendingToken) async {
        if (kDebugMode) {
          print('------codeSent--------$verificationId');
        }

        //verificationId:打ち込んだ電話番号に対する紐付けするID
        _ref.read(verificationIdRepositoryProvider.notifier).state = verificationId;
        // _ref.read(isAuthActionProvider.notifier).state = true;
        context.go('/register/tel_smsCode_page');
      },

      // Androidデバイスで自動SMSコード処理が失敗したときのタイムアウトを処理します。
      codeAutoRetrievalTimeout: (String verificationId) {
        if (kDebugMode) {
          print('-----codeAutoRetrievalTimeout---------');
        }
      },
    );
  }

  Future<void> signInWithTel(FirebaseAuth auth, String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    try {
      await _ref.read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      // throw CustomException(message: e.message);
    } catch (_) {}
  }

  @override
  Future<void> delete() async {
    try {
      await _ref.read(firebaseAuthProvider).currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      // throw CustomException(message: e.message);
    } catch (_) {}
  }

  Future<void> registerCustomStatus() async {
    try {
      final result = await FirebaseFunctions.instance
        .httpsCallable('registerCustomState')
        .call({"registerStatus": 1});
      print(result.data['state']);
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  Future<void> registerColorIndex(int index) async {
    try {
      final result = await FirebaseFunctions.instance
        .httpsCallable('registerColorIndex')
        .call({"colorIndex": index});
      print(result.data['state']);
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  // Future<void> removeCustomStatus() async {
  //   try {
  //     final result = await FirebaseFunctions.instance
  //         .httpsCallable('removeCustomStatus')
  //         .call({});
  //     print(result.data['state']);
  //   } on FirebaseFunctionsException catch (error) {
  //     print(error.code);
  //     print(error.details);
  //     print(error.message);
  //   }
  // }
}