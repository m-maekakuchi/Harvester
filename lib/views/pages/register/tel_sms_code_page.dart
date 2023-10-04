import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../../provider/providers.dart';
import '../../../repositories/auth_repository.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../widgets/green_button.dart';

class TelSmsCodePage extends ConsumerWidget {
  const TelSmsCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    String smsCode = '';
    final appBarColorIndex = ref.watch(colorProvider);

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: titleBox("認証コード", context),
          backgroundColor: themeColorChoice[appBarColorIndex],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children:[
                SizedBox(
                  height: getH(context, 5),
                ),
                Container(
                  width: getW(context, 90),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getH(context, 3),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          const Text(
                            "認証コード",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 1),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          const Text(
                            "認証コードを入力してください。",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 1),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          Expanded (
                            child: TextField(
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : textIconColor,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDarkMode ? Colors.white : textIconColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDarkMode ? Colors.white : textIconColor,
                                  ),
                                ),
                              ),
                              onChanged: (String value){
                                smsCode = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: getW(context, 5),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 4),
                      ),
                    ]
                  ),
                ),
                SizedBox(
                  height: getH(context, 5),
                ),
                GreenButton(
                  text: '完了',
                  fontSize: 18,
                  onPressed: () async{
                    try {
                      // ref.read(authControllerProvider.notifier).signInWithTel(verificationId, smsCode);
                      final verificationId = ref.watch(verificationIdRepositoryProvider);
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: smsCode
                      );
                      await ref.read(authViewModelProvider.notifier).signInWithCredential(credential);
                    } catch(e){
                      debugPrint(e.toString());
                    }
                  },
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}