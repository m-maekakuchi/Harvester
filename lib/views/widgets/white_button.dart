import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

class  WhiteButton extends StatelessWidget {
  const WhiteButton({
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
    return Container(
      width: getW(context, 60),
      height: getH(context, 6),
      margin: EdgeInsets.symmetric(vertical: getH(context, 2)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
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
          )
        ),
      ),
    );
  }
}
