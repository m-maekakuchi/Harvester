import 'package:flutter/material.dart';

import '../../handlers/padding_handler.dart';

Future<void> showWhiteModalBottomSheet({
  required BuildContext context,
  required Widget widget,
}) async {
  await showModalBottomSheet (
    backgroundColor: Colors.transparent, // ModalBottomSheetを角丸にするための設定
    isScrollControlled: true, // ModalBottomSheetの画面を半分以上にできる
    context: context,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: getH(context, 90),
        child: widget,
      );
    },
  );
}
