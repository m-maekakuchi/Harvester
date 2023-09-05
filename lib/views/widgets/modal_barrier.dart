import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

final modalBarrier = ColoredBox(
  color: modalBarrierColor,
  child: Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(themeColor), //  インジケーターの色
      strokeWidth: 6.0                                //  インジケーターの太さ
    ),
  )
);