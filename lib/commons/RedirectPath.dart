class RedirectPath {
  //未ログイン状態でアクセスしていいpath
  static const List<String> notLoginSignInPath = [
    '/',                                  // ウェルカムページ
    '/register/tel_identification_page',  // 電話番号認証
    '/register/user_info_page'            // ユーザー登録画面
  ];
}