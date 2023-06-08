import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../../repositories/auth_repository.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../widgets/GreenButton.dart';

class TelSmsCodePage extends ConsumerWidget {
  const TelSmsCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String smsCode = '';
    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(  // 幅を設定しないとcenterにならない
            width: getW(context, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
              children: [
                Image.asset(
                  width: getW(context, 10),
                  height: getH(context, 10),
                  'images/AppBar_logo.png'
                ),
                const Text("設定"),
              ]
            ),
          ),
        ),
        body: Center(
          child: Column(
            children:[
              SizedBox(
                height: getH(context, 5),
              ),
              Container(
                width: getW(context, 90),
                height: getH(context, 23),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                            style: TextStyle(color: textIconColor),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: textIconColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: textIconColor,
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
    );
  }
}