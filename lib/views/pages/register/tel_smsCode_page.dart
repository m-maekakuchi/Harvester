import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../../repositories/BaseAuthRepository.dart';
import '../../../viewModels/AuthController.dart';
import '../../widgets/GreenButton.dart';

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
                  await ref.read(authControllerProvider.notifier).signInWithCredential(credential);
                  context.go('/register/tel_smsCode_page');
                } catch(e){
                  debugPrint(e.toString());
                }
              },
            ),
          ]
        ),
      ),
    );
  }
}