import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

class  GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.onPressed,
  });

  final String text;
  final double fontSize;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getW(context, 90),
      height: getH(context, 7),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: textIconColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45)
          )
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
