import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../repositories/BaseAuthRepository.dart';
import '../../../viewModels/AuthController.dart';

class TelSmsCodePage extends ConsumerWidget {
  const TelSmsCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String smsCode = '';
    return Scaffold(
      appBar: AppBar(title: const Text('smsCode送信画面')),
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
                          keyboardType: TextInputType.number,
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
            SizedBox(
              width: getW(context, 80),
              height: getH(context, 7),
              child: ElevatedButton(
                onPressed: () async{
                  try {
                    // ref.read(authControllerProvider.notifier).signInWithTel(verificationId, smsCode);
                    final verificationId = ref.watch(verificationIdRepositoryProvider);
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode
                    );
                    await ref.read(authControllerProvider.notifier).signInWithCredential(credential);
                    context.go('/register/tel_smsCode_page');
                  } catch(e){
                    debugPrint(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(203, 255, 211, 1),
                    foregroundColor: const Color.fromRGBO(112, 112, 112, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)
                    )
                ),
                child: const Text(
                  "完了",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ),
            ),
          ]
        ),
      ),
    );
  }
}