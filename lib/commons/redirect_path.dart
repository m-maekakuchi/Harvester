class RedirectPath {
  //未ログイン状態でアクセスしていいpath
  static const List<String> notLoginSignInPath = [
    '/',                                  // ウェルカムページ
    '/register/tel_identification_page',  // 電話番号認証
    '/register/tel_smsCode_page'          // smsコード送信画面
  ];
}