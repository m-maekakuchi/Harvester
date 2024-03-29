import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../handlers/att_handler.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/green_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    // Build後にATTの確認のダイアログを出す、設定済みであれば表示されない
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => ATTHelper().attCheck());
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      // キーボードの表示領域を追加で取らず画面の上に被せて表示、電話番号入力画面からキーボード表示されたまま戻ってきたときのoverflow対策
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Container(
              margin: EdgeInsets.only(top: getH(context, 5)),
              width: double.infinity,
              height: getH(context, 20),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  isDarkMode ? 'images/logo_dark.png' : 'images/logo.png'
                ),
              ),
            ),
            SizedBox(
              height: getH(context, 40),
              child: Image.asset(
                'images/welcome_image.png'
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: getH(context, 2)),
                const Text(
                  'あなたのマンホールカードを\nシンプルに管理しましょう',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getH(context, 2)),
                GreenButton(
                  text: '電話番号',
                  fontSize: 20,
                  onPressed: () {
                    context.push('/register/tel_identification_page');
                  },
                ),
                SizedBox(height: getH(context, 2)),
                const Text(
                  'アカウント登録・ログインで利用規約に\n同意することになります',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getH(context, 5)),
              ],
            ),
          ]
        )
      ),
    );
  }
}