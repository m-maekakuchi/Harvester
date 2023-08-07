import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

// AppBarのTabBarのWidget
TabBar tabBar(List<SizedBox> tabList) {
  return TabBar(
    isScrollable: true,
    indicatorColor: textIconColor,
    indicatorWeight: 4,
    labelColor: textIconColor,
    labelStyle: const TextStyle(fontSize: 16),
    tabs: tabList,
  );
}