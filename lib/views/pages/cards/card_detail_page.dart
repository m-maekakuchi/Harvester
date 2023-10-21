import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/app_const.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/card_master_model.dart';
import '../../../models/card_model.dart';
import '../../../models/image_model.dart';
import '../../../provider/providers.dart';
import '../../../repositories/card_repository.dart';
import '../../../repositories/image_repository.dart';
import '../../../repositories/photo_repository.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/image_view_model.dart';
import '../../components/shimmer_loading_card_detail.dart';
import '../../components/carousel_slider_photos.dart';
import '../../widgets/text_message_dialog.dart';
import '../../widgets/white_button.dart';
import '../collections/my_card_edit_page.dart';

// immutable（不変）でない変数があるので、以下で警告文が表示されないようにしている
// ignore: must_be_immutable
class CardDetailPage extends ConsumerWidget {

  final CardMasterModel cardMasterModel;
  final bool myContain;

  final List<String?> imgUrlList = [];      // マイカードの画像URLのリスト
  final List<ImageModel> imgModelList = []; // マイカードのImageModelのリスト
  CardModel? cardModel;                     // マイカードに登録していない（あるいは取得に失敗した）場合は null

  CardDetailPage({
    super.key,
    required this.cardMasterModel,
    required this.myContain
  });

  Future<void> fetchCardModelAndImgUrl(WidgetRef ref) async {
    final uid = ref.read(authViewModelProvider.notifier).getUid();

    // マイカードに含まれていたら以下の処理を実行
    if (myContain) {
      cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${cardMasterModel.serialNumber}");
      // マイカードが取得できた場合
      if (cardModel != null) {
        // 画像のDocument参照を取得
        final photoDocRefList = cardModel!.photos;
        // photoフィールドが空ではないとき（空でなければリストが登録されている）
        if (photoDocRefList != null) {
          await Future.forEach(photoDocRefList, (photoDocRef) async {
            final photoModel = await PhotoRepository().getFromFireStore(photoDocRef as DocumentReference<Map<String, dynamic>>);
            if (photoModel != null) {
              // 画像URLのリストを作成
              final imgUrl = await ImageRepository().downloadOneImageFromStorage(cardMasterModel.serialNumber, photoModel.fileName!, ref);
              imgUrlList.add(imgUrl);
              // メモリにダウンロードした画像リストを作成
              final data = await ImageRepository().downloadImageToMemoryFromStorage(cardMasterModel.serialNumber, photoModel.fileName!, ref);
              final imgModel = ImageModel(
                fileName: photoModel.fileName,
                filePath: photoModel.filePath,
                imageFile: data
              );
              imgModelList.add(imgModel);
            }
          });
        }
      }
    }
  }

  // URLをWebブラウザで表示
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // カードのメインデータ（カード番号・都道府県・市町村・弾数）のColumnウィジェット
  Column cardMainInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          "第${cardMasterModel.version}弾",
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cardMasterModel.serialNumber,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // お気入り登録していたら、bookmarkアイコンを表示する
            cardModel != null && cardModel!.favorite == true
              ? Row (
                children: [
                  SizedBox(width: getW(context, 1)),
                  Icon(Icons.bookmark_rounded, color: favoriteColor)
                ],
              )
              : const SizedBox(),
          ],
        ),
        Text(
          "${cardMasterModel.prefecture} ${cardMasterModel.city}",
          style: const TextStyle(fontSize: 18),
        )
      ]
    );
  }

  // カード情報のタブのリスト
  List<Tab> cardDetailInfoTabList() {
    return List.generate(cardDetailInfoTabTitleList.length, (index) =>
      Tab(child: Text(cardDetailInfoTabTitleList[index], style: const TextStyle(fontSize: 16)))
    );
  }

  // カード情報のTabBar
  TabBar cardInfoTabBar(int index, BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return TabBar(
      labelColor: textIconColor,                                        // 選択時の文字色
      unselectedLabelColor: isDarkMode ? Colors.white : textIconColor,  // 未選択時の文字色
      indicator: BoxDecoration(
        color: themeColorChoice[index],
        borderRadius: BorderRadius.circular(20),
      ),
      tabs: cardDetailInfoTabList(),
    );
  }

  // 配布場所と住所のColumnウィジェット（この2つだけリストでFireStoreに登録されているため）
  Column cardListInfo(BuildContext context) {
    final length = cardMasterModel.distributeLocations.length;

    return Column (
      children: [
        for (var i = 0; i < length; i ++) ... {
          SizedBox(
            width: double.infinity,
            child: Text(
              cardMasterModel.distributeLocations[i]!,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16)
            ),
          ),
          if (cardMasterModel.distributeAddresses[i] != null) ... {
            SizedBox(
              width: double.infinity,
              child: Text(
                cardMasterModel.distributeAddresses[i]!,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16)
              ),
            ),
          },
          if (i != length - 1) SizedBox(height: getH(context, 3)),
        },
      ],
    );
  }

  // カード詳細情報部分のスクロールバー
  Widget scrollContainer(BuildContext context, Widget widget) {
    final ScrollController controller = ScrollController();
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      thickness: 10,
      radius: const Radius.circular(20),
      child: SingleChildScrollView(
        controller: controller,
        child: Container(
          padding: EdgeInsets.all(getH(context, 2)),
          child: widget,
        ),
      ),
    );
  }

  // タブとカード詳細情報（配置場所、配布時間、発行日）を合わせた、実線で囲んでいる部分
  Widget tabAndCardInfoContainer(BuildContext context, int index) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return DefaultTabController(
      length: cardDetailInfoTabTitleList.length, // タブの個数
      initialIndex: 0,
      child: Container(
        width: getW(context, 95),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDarkMode ? Colors.white : textIconColor, width: 0.6)
        ),
        child: Column(
          children: [
            /// タブの部分
            Container(
              margin: EdgeInsets.all(getW(context, 2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: cardInfoTabBar(index, context),
            ),
            /// カードの詳細情報の部分
            SizedBox(
              height: getH(context, 25), // TabBarViewの高さ
              child: TabBarView(
                children: [
                  scrollContainer(  // 配布場所
                    context,
                    cardListInfo(context)
                  ),
                  scrollContainer(  // 配布時間
                    context,
                    Text(
                      cardMasterModel.comment,
                      style: const TextStyle(fontSize: 16)
                    )
                  ),
                  scrollContainer(  // 発行日
                    context,
                    Text(cardMasterModel.issueDay.replaceAll("-", "/"),
                    style: const TextStyle(fontSize: 16))
                  ),
                ]
              ),
            )
          ]
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appBarColorIndex = ref.watch(colorProvider);

    return FutureBuilder(
      future: fetchCardModelAndImgUrl(ref),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoadingCardDetail();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: titleBox('Manhole Card', context),
              actions: actionList(context),
              backgroundColor: themeColorChoice[appBarColorIndex],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: getH(context, 1)),
                        /// 写真のスライダー
                        CarouselSliderPhotos(imgUrlList: imgUrlList, cardMasterModel: cardMasterModel),
                        SizedBox(height: getW(context, 1)),
                        /// カード番号・都道府県・市町村・段数
                        cardMainInfo(context),
                        SizedBox(height: getW(context, 3)),
                        ///  配布場所・配布時間・発行日
                        tabAndCardInfoContainer(context, appBarColorIndex),
                        SizedBox(height: getW(context, 3)),
                        ///  収集日とお気に入りマーク
                        cardModel != null && cardModel!.collectDay != null
                          ? Text(
                            "収集日　${convertDateTimeToString(cardModel!.collectDay!)}",
                            style: const TextStyle(
                              fontSize: 16,
                            )
                          )
                          : const SizedBox(),
                        ///  配布状況ボタン
                        WhiteButton(
                          text: '配布状況',
                          fontSize: 16,
                          onPressed: () async {
                            // stockLinkが「http」から始まるURLの場合、ブラウザで表示
                            // それ以外はstockLinkの文字列をダイアログで表示
                            if (cardMasterModel.stockLink!.startsWith("http")) {
                              _launchInBrowser(Uri.parse(cardMasterModel.stockLink!));
                            } else {
                              // 「〇〇までお問い合わせください」の「お問い合わせ」の前に改行を挿入する
                              String targetText = 'お問い合わせ';
                              int index = cardMasterModel.stockLink!.indexOf(targetText);
                              String newMessage = cardMasterModel.stockLink!.replaceFirst(targetText, '\n$targetText', index);
                              if (context.mounted) await textMessageDialog(context, newMessage);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // マイカードに登録していたら、編集画面に遷移するためのアイコンを表示
            floatingActionButton: cardModel != null
              ? FloatingActionButton(
                onPressed: () async {
                  if (cardModel!.collectDay != null) ref.read(cardEditPageCollectDayProvider.notifier).state = cardModel!.collectDay!;
                  if (cardModel!.favorite != null) ref.read(cardEditPageFavoriteProvider.notifier).state = cardModel!.favorite!;

                  // カード追加の画面でimageListProviderが変更されている可能性があるので、
                  // 初期化して選択中のカードに登録されている画像をセット
                  ref.read(imageListProvider.notifier).init();
                  await Future.forEach(imgModelList, (item) async {
                    await ref.read(imageListProvider.notifier).add(item);
                  });

                  // showModalBottomSheetを使用して、カード編集画面を表示
                  if (context.mounted) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,                  // SafeAreaを挿入
                      barrierColor: Colors.transparent, // 後ろの画面の色
                      builder: (BuildContext context) {
                        return MyCardEditPage(
                          cardMasterModel: cardMasterModel,
                          cardModel: cardModel!,
                          preImageModelList: imgModelList,
                        );
                      }
                    );
                  }
                },
                backgroundColor: themeColorChoice[appBarColorIndex],
                child: const Icon(Icons.edit_rounded, color: textIconColor),
              )
              : const SizedBox()
          );
        }
      }
    );
  }

}