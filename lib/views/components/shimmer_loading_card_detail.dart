import 'package:flutter/material.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../commons/app_bar_contents.dart';
import '../widgets/shimmer.dart';

class ShimmerLoadingCardDetail extends StatelessWidget {
  const ShimmerLoadingCardDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleBox('Manhole Card', context),
        actions: actionList(context),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),  // スクロール不可にする
        child: Center(
          child: Column(
            children: [
              SizedBox(height: getH(context, 1)),
              // 写真のスライダー
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ShimmerWidget.roundedRectangular(
                  width: getW(context, 72),
                  height: getW(context, 54),
                  borderRadius: 20,
                ),
              ),
              SizedBox(height: getW(context, 1)),
              // スライダーの丸
              ShimmerWidget.roundedRectangular(
                width: getW(context, 4),
                height: getW(context, 4),
                borderRadius: 45,
              ),
              SizedBox(height: getW(context, 3)),
              // 段数
              ShimmerWidget.roundedRectangular(
                width: getW(context, 30),
                height: getW(context, 8),
                borderRadius: 0,
              ),
              SizedBox(height: getW(context, 1)),
              // カード番号
              ShimmerWidget.roundedRectangular(
                width: getW(context, 50),
                height: getW(context, 10),
                borderRadius: 0,
              ),
              SizedBox(height: getW(context, 1)),
              // 都道府県と市町村
              ShimmerWidget.roundedRectangular(
                width: getW(context, 40),
                height: getW(context, 8),
                borderRadius: 0,
              ),
              SizedBox(height: getW(context, 3)),
              // 詳細情報
              ShimmerWidget.roundedRectangular(
                width: getW(context, 95),
                height: getH(context, 30),
                borderRadius: 20,
              ),
              SizedBox(height: getW(context, 3)),
              // 収集日
              ShimmerWidget.roundedRectangular(
                width: getW(context, 40),
                height: getW(context, 8),
                borderRadius: 0,
              ),
              SizedBox(height: getW(context, 3)),
              //  配布状況ボタン
              ShimmerWidget.roundedRectangular(
                width: getW(context, 60),
                height: getW(context, 10),
                borderRadius: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
