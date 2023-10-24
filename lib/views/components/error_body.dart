import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../commons/message.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/green_button.dart';

class ErrorBody extends StatelessWidget {

  final String errMessage;
  final GestureTapCallback? onPressed;

  const ErrorBody({
    super.key,
    required this.errMessage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getH(context, 10)),
        const Center(child: Icon(
          Icons.error_outline_rounded,
          color: textIconColor,
          size: 60,
        )),
        SizedBox(height: getH(context, 2)),
        Text(
          errMessage,
          style: const TextStyle(fontSize: 16),
        ),
        const Text(
          tryAgainLaterMessage,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: getH(context, 2)),
        GreenButton(
          text: "閉じる",
          fontSize: 16,
          onPressed: onPressed,
        )
      ],
    );
  }
}