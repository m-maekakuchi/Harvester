import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

Future<void> showWhiteModalBottomSheet({
  required BuildContext context,
  required Widget widget,
}) async {
  bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

  await showModalBottomSheet (
    backgroundColor: Colors.transparent, // ModalBottomSheetを角丸にするための設定
    isScrollControlled: true, // ModalBottomSheetの画面を半分以上にできる
    context: context,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? darkModeBackgroundColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: getH(context, 90),
        child: widget,
      );
    },
  );
}
