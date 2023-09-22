import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

const modalBarrier = ColoredBox(
  color: modalBarrierColor,
  child: Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white), //  インジケーターの色
      strokeWidth: 5.0                                //  インジケーターの太さ
    ),
  )
);