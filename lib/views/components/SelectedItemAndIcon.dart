import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

class SelectedItemAndIcon extends StatelessWidget {

  /// 選択されたアイテム
  final String text;

  const SelectedItemAndIcon({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          style: const TextStyle(
            color: textIconColor,
            fontSize: 16,
          ),
          text,
        ),
        const Icon(
          Icons.arrow_drop_down_rounded,
          size: 40,
          color: textIconColor,
        ),
      ],
    );;
  }
}
