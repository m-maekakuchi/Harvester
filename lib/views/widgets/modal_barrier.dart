import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

const modalBarrier = ColoredBox(
  color: modalBarrierColor,
  child: Center(
    child: CircularProgressIndicator(),
  )
);