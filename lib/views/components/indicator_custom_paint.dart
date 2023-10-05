import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import 'ratio_indicator.dart';

const kElevation = 10.0;

// インジケーター
Widget indicatorCustomPaint(
  indicatorSize,  // ゲージの大きさ
  place,
  myCardsNum,
  allCardsNum,
  context,
  colorIndex
) {
  final percentage = myCardsNum / allCardsNum;

  return CustomPaint(
    painter: RatioIndicatorWidget(
      percentage: percentage,                 // バッテリーレベルの割合
      textCircleRadius: indicatorSize * 0.5,  // 内側に表示される白丸の半径
      spaceLen: indicatorSize * 0.05,         // 円とゲージ間の長さ
      lineLen: indicatorSize * 0.12,          // ゲージの長さ
      colorIndex: colorIndex,
    ),
    child: Container(
      padding: EdgeInsets.all(indicatorSize * 0.22),
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
                style: TextStyle(color: textIconColor, fontSize: indicatorSize * 0.18, fontWeight: FontWeight.bold),
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