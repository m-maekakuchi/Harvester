import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/green_button.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Image.asset(
              width: getW(context, 80),
              height: getH(context, 30),
              'images/Harvester_logo.png'
            ),
            Image.asset(
              width: getW(context, 70),
              height: getH(context, 25),
              'images/manhole.png'
            ),
            // GreenButton(
            //   text: 'Google',
            //   fontSize: 20,
            //   onPressed: () {
            //     // ref.read(authViewModelProvider.notifier).signInWithGoogle();
            //     context.go('/cards_list_page');
            //   },
            // ),
            GreenButton(
              text: '電話番号',
              fontSize: 20,
              onPressed: () {
                context.go('/register/tel_identification_page');
              },
            ),
          ]
        )
      ),
    );
  }
}