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
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,  // 親の中に収まるまで縮小する。すでに収まっている場合、拡大はしない。
              child: Text(
                text,
                style: const TextStyle(color: textIconColor),
                maxLines: 1,
              )
            ),
          ),
        ),
        const Icon(
          Icons.arrow_drop_down_rounded,
          size: 40,
          color: textIconColor,
        ),
      ],
    );
  }
}
