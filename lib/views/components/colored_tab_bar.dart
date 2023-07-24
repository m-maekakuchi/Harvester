import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

// AppBarのbottomにあるTabBar（全国 or 都道府県）の色を設定
class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget tabBar;

  const ColoredTabBar({super.key, required this.tabBar});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  Size get preferredSize => tabBar.preferredSize;
}