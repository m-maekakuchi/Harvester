import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/green_button.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              Container(
                margin: EdgeInsets.only(top: getH(context, 2)),
                width: getW(context, 80),
                child: Image.asset(
                  'images/logo.png'
                ),
              ),
              Image.asset(
                'images/welcome_image.png'
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'あなたのマンホールカードを\nシンプルに管理しましょう',
                    style: TextStyle(
                      color: textIconColor,
                      fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getH(context, 2)),
                  GreenButton(
                    text: '電話番号',
                    fontSize: 20,
                    onPressed: () {
                      context.go('/register/tel_identification_page');
                    },
                  ),
                  SizedBox(height: getH(context, 2)),
                  const Text(
                    'アカウント登録・ログインで利用規約に\n同意することになります',
                    style: TextStyle(
                        color: textIconColor,
                        fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getH(context, 2))
                ],
              ),
            ]
          )
        ),
      ),
    );
  }
}