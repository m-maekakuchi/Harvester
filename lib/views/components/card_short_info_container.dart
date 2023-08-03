import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/repositories/card_repository.dart';
import 'package:harvester/viewModels/auth_view_model.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';
import '../../models/card_master_model.dart';
import '../../models/card_model.dart';
import '../../repositories/image_repository.dart';
import '../../repositories/photo_repository.dart';
import '../pages/cards/card_detail_page.dart';
import '../widgets/cached_network_image.dart';

// カード一覧画面のカード情報のContainer
class CardShortInfoContainer extends ConsumerWidget {

  /// マスターカード
  final CardMasterModel cardMasterModel;
  /// 画像
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
        final uid = ref.read(authViewModelProvider.notifier).getUid();
        DateTime? collectDay;
        List<String?>? imgUrlList;
        // マイカードに登録していた場合
        if (myContain) {
          // 収集日を取得
          collectDay = await CardRepository().getCollectDay("$uid${cardMasterModel.serialNumber}");
          // 画像のURLリストを取得
          CardModel? cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${cardMasterModel.serialNumber}");
          // マイカードが取得できて、photoフィールドが空ではないとき
          if (cardModel != null && cardModel.photos!.isNotEmpty) {
            // 登録されている画像を取得
            final photoDocRefList = cardModel.photos;
            if (photoDocRefList != null) {
              imgUrlList = [];
              await Future.forEach(photoDocRefList, (photoDocRef) async {
                final photoModel = await PhotoRepository().getFromFireStore(photoDocRef as DocumentReference<Map<String, dynamic>>);
                if (photoModel != null) {
                  // 画像URLを取得
                  final imgUrl = await ImageRepository().downloadOneImageFromFireStore(cardMasterModel.serialNumber, photoModel.fileName!, ref);
                  imgUrlList!.add(imgUrl);
                }
              });
            }
          }
        }
        // showModalBottomSheetを使用して、カード詳細画面を表示
        if (context.mounted) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return CardDetailPage(
                cardMasterModel: cardMasterModel,
                imgUrlList: imgUrlList,
                favorite: favorite,
                collectDay: collectDay,
                myContain: myContain,
              );
            }
          );
        }
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
            // 画像
            imgUrl != null
              ? cachedNetworkImage(imgUrl!)
              : Image.asset('images/GrayBackImg.png'),
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

