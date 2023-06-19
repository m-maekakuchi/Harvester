import 'package:flutter/material.dart';

// AppBarのbottomにあるTabBar（全国 or 都道府県）の色を設定
class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget tabBar;
  final Color color;

  const ColoredTabBar({super.key, required this.tabBar, required this.color});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: color,
      child: tabBar,
    );
  }

  @override
  Size get preferredSize => tabBar.preferredSize;
}