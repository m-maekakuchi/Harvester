import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

// カード一覧画面のカード情報のContainer
class CardShortInfoContainer extends ConsumerWidget {

  /// 画像
  final String? imageUrl;
  /// 都道府県
  final String prefecture;
  /// 市町村
  final String city;
  /// 段数
  final int version;
  /// カード番号
  final String serialNumber;
  /// お気に入り登録
  final bool? favorite;

  const CardShortInfoContainer({
    Key? key,
    this.imageUrl,
    required this.prefecture,
    required this.city,
    required this.version,
    required this.serialNumber,
    required this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final sizedBoxFixedHeight = SizedBox(height: getH(context, 0.2));

    return GestureDetector(
      onTap: () {
        context.push('/cards/card_detail_page');
      },
      child: Container(
        height: getH(context, 16),
        width: getW(context, 95),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.centerLeft,  // Containerから画像がはみ出ないように設定
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: textIconColor),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(5, 5),
            )
          ],
        ),
        child: Row(
          children: [
            (imageUrl != null)
              ? CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error_rounded)),
              )
              : Image.asset(
                'images/GrayBackImg.png'
              ),
            // カード情報
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizedBoxFixedHeight,
                        Text(
                          prefecture,
                          style: const TextStyle(fontSize: 14),
                        ),
                        sizedBoxFixedHeight,
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            city,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        sizedBoxFixedHeight,
                        Text(
                          "第$version弾",
                          style: const TextStyle(fontSize: 14),
                        ),
                        sizedBoxFixedHeight,
                        Text(
                          serialNumber,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: getH(context, 0.2),),
                      ]
                    ),
                  ),
                  Positioned( // お気に入りアイコンを親の右下に配置
                    bottom: getW(context, 2),
                    right: getW(context, 2),
                    child: (favorite ?? false)  // favoriteがtrueの場合
                      ? Icon(
                          Icons.bookmark_outlined,
                          size: 25,
                          color: Colors.yellow[700]
                        )
                      : const SizedBox(), // favoriteがfalseの場合
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}

