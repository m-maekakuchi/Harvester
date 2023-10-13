import 'package:firebase_auth/firebase_auth.dart';

import '../commons/message.dart';

class AuthExceptionHandler {

  static exceptionMessage(FirebaseAuthException e) {
    String message = "";

    switch (e.code) {
    // case 'invalid-credential':
    //   message = "";
    //   break;
      // アカウントが無効のとき
      case 'user-disabled':
        message = userDisabledErrorMessage;
        break;
      // verification id が正常に生成できなかったとき
      case 'invalid-verification-id':
        message = invalidVerificationIdErrorMessage;
        break;
      // smsコードを間違って入力したとき
      case 'invalid-verification-code':
        message = invalidVerificationCodeErrorMessage;
        break;
      // アクセスが集中しているとき
      case 'too-many-requests':
        message = tooManyRequestsErrorMessage;
        break;
      default:
        message = undefinedErrorMessage;
        break;
    }
    return message;
  }
}