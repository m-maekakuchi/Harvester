import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_color.dart';
import '../../commons/app_const.dart';
import '../../handlers/padding_handler.dart';
import '../../models/card_master_model.dart';
import '../pages/cards/card_detail_page.dart';
import '../widgets/cached_network_image.dart';

// カード一覧画面のカード情報のContainer
class CardShortInfoContainer extends ConsumerWidget {

  /// マスターカード
  final CardMasterModel cardMasterModel;
  /// 画像URL
  final String? imgUrl;
  /// お気に入り登録されているか
  final bool? favorite;
  /// マイカードに登録されているか
  final bool myContain;

  const CardShortInfoContainer({
    super.key,
    required this.cardMasterModel,
    required this.imgUrl,
    required this.favorite,
    required this.myContain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool isTabletSize = MediaQuery.of(context).size.width > tabletWidth;

    final sizedBoxFixedHeight = SizedBox(height: getH(context, 0.2));

    return GestureDetector(
      onTap: () async {
        // showModalBottomSheetを使用して、カード詳細画面を表示
        if (context.mounted) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true, // 高さを半分以上にできる
            useSafeArea: true,        // SafeAreaを挿入
            barrierColor: Colors.transparent, // 後ろの画面の色
            builder: (BuildContext context) {
              return CardDetailPage(
                cardMasterModel: cardMasterModel,
                myContain: myContain,
              );
            }
          );
        }
      },
      child: Container(
        height: getH(context, 16),
        width: getW(context, 96),
        clipBehavior: Clip.antiAlias,     // Containerから画像がはみ出ないように設定
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: isDarkMode ? Colors.black : textIconColor),
          borderRadius: BorderRadius.circular(20),
          color: !isDarkMode
            ? Colors.white
            : Colors.black,
        ),
        child: Row(
          children: [
            // 画像
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              // 登録画像があれば、その1枚目を表示
              child: Container(
                width: getW(context, 48),
                height: getH(context, 100),
                color: isDarkMode ? darkModeBackgroundColor : modalBarrierColor,
                child: imgUrl != null                           // nullの場合はアイコンを表示
                  ? imgUrl!.contains(containGitHubImageStr)     // GitHubのURLの場合、モザイクをかける
                    ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: isTabletSize ? 6 : 3, sigmaY: isTabletSize ? 6 : 3),
                      child: cachedNetworkImage(imgUrl!),
                    )
                    : cachedNetworkImage(imgUrl!)
                  : const Center(child: Icon(Icons.error_rounded))
              ),
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
                          cardMasterModel.prefecture,
                          style: const TextStyle(fontSize: 14),
                        ),
                        sizedBoxFixedHeight,
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            cardMasterModel.city,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        sizedBoxFixedHeight,
                        Text(
                          "第${cardMasterModel.version}弾",
                          style: const TextStyle(fontSize: 14),
                        ),
                        sizedBoxFixedHeight,
                        Text(
                          cardMasterModel.serialNumber,
                          style: const TextStyle(fontSize: 14),
                        ),
                        sizedBoxFixedHeight,
                      ]
                    ),
                  ),
                  // お気に入りアイコン
                  Positioned( // 親Widgetの右下に配置
                    bottom: getW(context, 2),
                    right: getW(context, 2),
                    child: (favorite ?? false)  // favoriteがtrueの場合
                      ? Icon(
                          Icons.bookmark_outlined,
                          size: 25,
                          color: favoriteColor
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

