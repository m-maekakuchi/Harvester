import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master.dart';
import '../../commons/app_color.dart';
import '../../commons/irregular_card_number.dart';
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
    this.imgUrl,
    required this.favorite,
    required this.myContain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final sizedBoxFixedHeight = SizedBox(height: getH(context, 0.2));

    return GestureDetector(
      onTap: () async {
        // showModalBottomSheetを使用して、カード詳細画面を表示
        if (context.mounted) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
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
        width: getW(context, 95),
        clipBehavior: Clip.antiAlias,     // Containerから画像がはみ出ないように設定
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
            // 画像
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              // 登録画像があれば、その1枚目を表示
              // 登録画像がない場合、カード番号がirregularであればベージュのカード画像、それ以外はその地方の色のカード画像を表示
              child: imgUrl != null
                ? cachedNetworkImage(imgUrl!, cardMasterModel)
                : irregularCardMasterNumbers.containsValue(cardMasterModel.serialNumber)
                  ? Image.asset('images/irregular.png')
                  : Image.asset('images/${regionMap[cardMasterModel.prefecture]}.png')
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

