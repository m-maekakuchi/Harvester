import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../commons/message.dart';
import '../provider/providers.dart';
import '../repositories/auth_repository.dart';
import '../viewModels/auth_view_model.dart';
import '../views/widgets/text_message_dialog.dart';
import 'firebase_auth_exception_handler.dart';

class PhoneVerification {
  final Ref ref;
  PhoneVerification(this.ref);

  Future<void> verification(
    BuildContext context,
    TextEditingController smsCodeController
  ) async {
    final notifier = ref.read(phoneVerificationStateProvider.notifier);
    notifier.state = const AsyncValue.loading();

    try {
      final verificationId = ref.watch(verificationIdRepositoryProvider);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCodeController.text
      );
      // throw FirebaseAuthException(code: '');
      // throw Exception("FirebaseAuthException以外のエラー");
      await ref.read(authViewModelProvider.notifier).signInWithCredential(credential);
      notifier.state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint(e.toString());
      final errorMessage = AuthExceptionHandler.exceptionMessage(e);
      notifier.state = const AsyncValue.data(null);
      if (errorMessage == undefinedErrorMessage) {
        context.go("/error_page");
      } else {
        textMessageDialog(context, errorMessage);
      }
    } catch(e) {
      debugPrint(e.toString());
      notifier.state = const AsyncValue.data(null);
      context.go("/error_page");
    }
  }
}