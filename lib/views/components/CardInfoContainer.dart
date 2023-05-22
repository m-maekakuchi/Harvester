import 'package:flutter/material.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

// カード一覧画面のカード情報のContainer
class CardInfoContainer extends StatelessWidget {
  const CardInfoContainer({
    super.key,
    required this.image,
    required this.city,
    required this.version,
    required this.serialNumber,
  });

  /// 画像
  final String image;
  /// 市町村
  final String city;
  /// 段数
  final int version;
  /// カード番号
  final String serialNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getH(context, 13),
      width: getW(context, 90),
      margin: EdgeInsets.only(bottom: getH(context, 1)),
      clipBehavior: Clip.antiAlias, // Containerから画像がはみ出ないように設定
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: textIconColor),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: Row(
        children: [
          /// DBからの取得するので後で変更
          Image.network(
            image
          ),
          // カード情報
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(city, style: const TextStyle(fontSize: 15),),
                Text("第$version弾", style: const TextStyle(fontSize: 14),),
                Text(serialNumber, style: const TextStyle(fontSize: 14),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
