import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

// カード一覧画面のカード情報のContainer
class CardShortInfoContainer extends StatelessWidget {
  const CardShortInfoContainer({
    super.key,
    required this.image,
    required this.prefecture,
    required this.city,
    required this.version,
    required this.serialNumber,
    // this.favorite,
  });

  /// 画像
  final String image;
  /// 都道府県
  final String prefecture;
  /// 市町村
  final String city;
  /// 段数
  final int version;
  /// カード番号
  final String serialNumber;
  // /// お気に入りかどうか
  // final bool favorite;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        context.push('/cards/card_detail_page');
      },
      child: Container(
        height: getH(context, 13),
        width: getW(context, 95),
        margin: EdgeInsets.only(bottom: getH(context, 1)),
        clipBehavior: Clip.antiAlias, // Containerから画像がはみ出ないように設定
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: textIconColor),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(5, 5),
          )],
        ),
        child: Row(
          children: [
            /// DBからの取得するので後で変更
            Image.network(
              image
            ),
            // カード情報
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // favoriteがnullでなければその値が使われ、nullであれば??隣の値（false）が使われる
                        // MyCardsでお気に入り登録していたらアイコンが表示される
                        // Container(
                        //   child: (favorite ?? false)
                        //     ? const Icon(Icons.bookmark_outlined) // favoriteがtrueの場合
                        //     : const SizedBox(), // favoriteがfalseの場合
                        // ),
                        Text(prefecture, style: const TextStyle(fontSize: 14),),
                        SizedBox(height: getH(context, 0.2),),
                        Text(city, style: const TextStyle(fontSize: 17),),
                        SizedBox(height: getH(context, 0.2),),
                        Text("第$version弾", style: const TextStyle(fontSize: 14),),
                        SizedBox(height: getH(context, 0.5),),
                        Text(serialNumber, style: const TextStyle(fontSize: 14),),
                      ]
                    ),
                  ),
                  /// ----お気に入り登録してたら表示したい----
                  Positioned( // お気に入りアイコンを親の右下に配置
                    bottom: getW(context, 2),
                    right: getW(context, 2),
                    child: Icon(
                      Icons.bookmark_outlined,
                      size: 25,
                      color: Colors.yellow[700],
                    ),
                  ),
                  /// ------------------------------------
                ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}