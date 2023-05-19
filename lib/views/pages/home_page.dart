import 'package:flutter/material.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../commons/app_color.dart';
import '../widgets/ratioIndicatorWidget.dart';

const kElevation = 10.0;
const indicatorPlace = [
  '全国',
  '北海道',
  '東北',
  '関東',
  '中部',
  '近畿',
  '中国',
  '四国',
  '九州',
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];
const myCardsNum = [
  40,
  50,
  2,
  0,
  8,
  0,
  0,
  0,
  0,
  10,
  1,
  1,
  0,
  0,
  0,
  0,
  2,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
];
const allCardsNum = [
  300,
  50,
  50,
  100,
  50,
  50,
  50,
  50,
  50,
  50,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
];

// 地方区分の数
const areaNum = 8;
// 都道府県の数
const prefecturesNum = 47;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getH(context, 3),
            ),
            // 全国のインジケーター
            _indicator(15, 20, getW(context, 40), indicatorPlace[0], myCardsNum[0] / allCardsNum[0], myCardsNum[0], allCardsNum[0], context),
            // 地方のインジケーター
            for (int i = 1; i < areaNum; i += 2) ... {
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j <= 1; j ++) ... {
                    _indicator(10, 13, getW(context, 30), indicatorPlace[i + j], myCardsNum[i + j] / allCardsNum[i + j], myCardsNum[i + j], allCardsNum[i + j], context),
                  }
                ],
              ),
            },
            // 都道府県のインジケーター
            for (int i = 9; i < 55; i += 3) ... {
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    for (int j = 0; j <= 2; j ++) ... {
                      // 最後の行が1つ分空くので空白を設置
                      if (i == 54 && j == 2) ... {
                        SizedBox(
                          width: getW(context, 30) + getW(context, 30) * 0.06,
                        ),
                      } else ... {
                        _indicator(5, 7, getW(context, 20), indicatorPlace[i + j], myCardsNum[i + j] / allCardsNum[i + j], myCardsNum[i + j], allCardsNum[i + j], context),
                      }
                    },
                  // }
                ],
              ),
            },
            SizedBox(
              height: getH(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _indicator(
    spaceLen,  // 円とゲージ間の長さ
    lineLen,  // ゲージの長さ
    indicatorSize,  // ゲージの大きさ
    place,
    percentage, // バッテリーレベルの割合
    myCardsNum,
    allCardsNum,
    context
) {

  return CustomPaint(
    painter: RatioIndicatorWidget(
      percentage: percentage, // バッテリーレベルの割合
      textCircleRadius: indicatorSize * 0.5, //内側に表示される白丸の半径
      spaceLen: spaceLen, // 円とゲージ間の長さ
      lineLen: lineLen, // ゲージの長さ
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