import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/app_const.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/card_master_model.dart';
import '../../widgets/carousel_slider_photos.dart';
import '../../widgets/text_message_dialog.dart';
import '../../widgets/white_button.dart';

class CardDetailPage extends ConsumerWidget {
  final CardMasterModel cardMasterModel;
  final List<String?>? imgUrlList;
  final bool? favorite;
  final DateTime? collectDay;
  final bool myContain;

  const CardDetailPage({
    super.key,
    required this.cardMasterModel,
    required this.imgUrlList,
    required this.favorite,
    required this.collectDay,
    required this.myContain
  });

  // URLをWebブラウザで表示
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // カード番号・都道府県・市町村・弾数のColumnウィジェット
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
            favorite != null && favorite == true
              ? Row (
                children: [
                  SizedBox(width: getW(context, 1)),
                  Icon(Icons.bookmark_rounded, color: favoriteColor)
                ],
              )
              : const SizedBox(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${cardMasterModel.prefecture} ${cardMasterModel.city}",
              style: const TextStyle(fontSize: 18),
            )
          ],
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
  TabBar cardInfoTabBar() {
    return TabBar(
      labelColor: textIconColor,            // 選択時の文字色
      unselectedLabelColor: textIconColor,  // 未選択時の文字色
      indicator: BoxDecoration(
        color: themeColor,
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

  // 配置場所、配布時間、発行日（スクロール可能）
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

  // タブと情報合わせた、実線で囲んでいる部分
  Widget tabAndCardInfoContainer(BuildContext context) {
    return DefaultTabController(
      length: cardDetailInfoTabTitleList.length, // タブの個数
      initialIndex: 0,
      child: Container(
        width: getW(context, 95),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textIconColor, width: 0.6)
        ),
        child: Column(
          children: [
            // タブの部分
            Container(
              margin: EdgeInsets.only(top: getW(context, 2), left: getW(context, 2), right: getW(context, 2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cadInfoTabBarNoSelectColor,
              ),
              child: cardInfoTabBar(),
            ),
            // カードの詳細情報の部分
            SizedBox(
              height: getH(context, 20), // TabBarViewの高さ
              child: TabBarView(
                children: [
                  scrollContainer(context, cardListInfo(context)),
                  scrollContainer(context, Text(cardMasterModel.comment, style: const TextStyle(fontSize: 16))),
                  scrollContainer(context, Text(cardMasterModel.issueDay.replaceAll("-", "/"), style: const TextStyle(fontSize: 16))),
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

    return Scaffold(
      appBar: AppBar(
        title: titleBox('Manhole Card', context),
        actions: actionList(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getH(context, 1)),
                  // 写真のスライダー
                  CarouselSliderPhotos(imgUrlList: imgUrlList),
                  SizedBox(height: getW(context, 1)),
                  // カード番号・都道府県・市町村・段数
                  cardMainInfo(context),
                  SizedBox(height: getW(context, 3)),
                  //  配布場所・配布時間・発行日
                  tabAndCardInfoContainer(context),
                  SizedBox(height: getW(context, 3)),
                  //  収集日とお気に入りマーク
                  collectDay != null
                    ? Text('収集日: ${DateFormat('yyyy/MM/dd').format(collectDay!)}', style: const TextStyle(fontSize: 16))
                    : const SizedBox(),
                  //  配布状況ボタン
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
      floatingActionButton: myContain == true
        ? FloatingActionButton(
            onPressed: () {

            },
            backgroundColor: themeColor,
            child: const Icon(Icons.edit_rounded, color: textIconColor),
          )
        : const SizedBox()
    );
  }

}