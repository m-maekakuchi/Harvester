import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import '../../provider/providers.dart';

class GreenButton extends ConsumerWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.onPressed,
  });

  final String text;
  final double fontSize;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appBarColorIndex = ref.watch(colorProvider);

    return SizedBox(
      width: getW(context, 90),
      height: getH(context, 7),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColorChoice[appBarColorIndex],
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
