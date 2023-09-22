import 'dart:math';

import 'package:flutter/material.dart';

import '../../commons/app_color.dart';

class RatioIndicatorWidget extends CustomPainter {
  final double percentage; // バッテリーレベルの割合
  final double textCircleRadius; // 内側に表示される白丸の半径
  final int spaceLen;  // 円とゲージ間の長さ
  final int lineLen; // ゲージの長さ
  final int colorIndex;

  RatioIndicatorWidget({
    required this.percentage,
    required this.textCircleRadius,
    required this.spaceLen,
    required this.lineLen,
    required this.colorIndex
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < (360 * percentage); i += 5) {
      final per = i / 360.0;
      // 割合（0~1.0）からグラデーション色に変換
      final color = ColorTween(
        begin: themeColorChoice[colorIndex],
        end: indicatorLastColorList[colorIndex],
      ).lerp(per)!;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      // const spaceLen = 16;  // 円とゲージ間の長さ
      // const lineLen = 18; // ゲージの長さ
      final angle = (2 * pi * per) - (pi / 2); // 0時方向から開始するため-90度ずらす

      // 円の中心座標
      final offset0 = Offset(size.width * 0.5, size.height * 0.5);
      // 線の内側部分の座標
      final offset1 = offset0.translate(
        (textCircleRadius + spaceLen) * cos(angle),
        (textCircleRadius + spaceLen) * sin(angle),
      );
      // 線の外側部分の座標
      final offset2 = offset1.translate(
        lineLen * cos(angle),
        lineLen * sin(angle),
      );

      canvas.drawLine(offset1, offset2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}