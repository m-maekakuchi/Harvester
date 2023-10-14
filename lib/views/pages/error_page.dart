import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../commons/app_color.dart';
import '../../commons/message.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/green_button.dart';

class ErrorPage extends StatelessWidget {
  final String? errorCode;
  const ErrorPage(this.errorCode, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: getH(context, 10)),
          const Center(child: Icon(
            Icons.error_outline_rounded,
            color: textIconColor,
            size: 60,
          )),
          SizedBox(height: getH(context, 2)),
          Text(
            errorCode != null ? "$undefinedErrorMessage$errorCode" : undefinedErrorMessage,
            style: const TextStyle(fontSize: 16),
          ),
          const Text(
            "しばらく経ってからご利用ください。",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: getH(context, 2)),
          GreenButton(
            text: "閉じる",
            fontSize: 16,
            onPressed: () {
              context.go("/");
            }
          )
        ],
      )
    );
  }
}