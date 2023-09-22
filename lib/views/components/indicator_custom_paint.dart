import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import 'ratio_indicator.dart';

const kElevation = 10.0;

// インジケーター
Widget indicatorCustomPaint(
  spaceLen,       // 円とゲージ間の長さ
  lineLen,        // ゲージの長さ
  indicatorSize,  // ゲージの大きさ
  place,
  percentage,     // バッテリーレベルの割合
  myCardsNum,
  allCardsNum,
  context,
  colorIndex
) {
  return CustomPaint(
    painter: RatioIndicatorWidget(
      percentage: percentage,                 // バッテリーレベルの割合
      textCircleRadius: indicatorSize * 0.5,  // 内側に表示される白丸の半径
      spaceLen: spaceLen,                     // 円とゲージ間の長さ
      lineLen: lineLen,                       // ゲージの長さ
      colorIndex: colorIndex,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: indicatorSize * 0.28, horizontal: indicatorSize * 0.3),
      child: Material(
        color: Colors.white,
        elevation: kElevation,
        borderRadius: BorderRadius.circular(indicatorSize * 0.5),
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                place,
                style: TextStyle(color: textIconColor, fontSize: indicatorSize * 0.15),
              ),
              SizedBox(
                height: getH(context, 1),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(color: textIconColor, fontSize: indicatorSize * 0.2, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: getH(context, 1),
              ),
              Text(
                '$myCardsNum / $allCardsNum',
                style: TextStyle(color: textIconColor, fontSize: indicatorSize * 0.15),
              )
            ],
          ),
        ),
      ),
    ),
  );
}