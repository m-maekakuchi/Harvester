import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';
import 'package:harvester/handlers/padding_handler.dart';
import 'package:harvester/views/widgets/WhiteButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/card_info_tab.dart';
import '../../widgets/CarouselSliderPhotos.dart';

/// 写真
const List<String> imgList = [
  'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
  'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
  'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
  'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
];

/// カード情報
const card = {
  "version": "1",
  "card_number": "01-454-A001",
  "prefecture": "北海道",
  "city": "当麻町",
  "distribute_place": "【火曜日】当麻町役場まちづくりりりりりりりりりりり\n北海道上川郡当麻町4条3丁目1番41号\n\n【火曜日以外】当麻町郷土資料ここから\n北海道上川郡当麻町3条2丁目11番1号\nあ\nあ\nあ\nあ\nあ",
  "distribute_time": "【火曜日】8:30～17:15\n【火曜日以外】10:00～19:00\nあ\nあ\nあ\nあ\nあ\nあ\nあ\nあ\nあ\nあ",
  "issue_date": "2021/1/28",
  "url": 'https://www.jswa.go.jp/company/50th-anniversary/manhole-card.html',
};

// 収集日
const collectionDay = "2023/4/5";
// お気に入り登録されているかどうか
const bookmark = true;

class CardDetailPage extends ConsumerWidget {
  const CardDetailPage({super.key});

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ScrollController _controllerOne = ScrollController();
    final toLaunch = Uri.parse(card["url"]!);

    // 詳細情報のTabBar
    final cardInfoTabBar = TabBar(
      labelColor: textIconColor,  // 選択時の文字色
      unselectedLabelColor: textIconColor,  // 未選択時の文字色
      indicator: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      tabs: cardInfoTab,
    );

    // 詳細情報の内容
    Widget singleCardDetailInfo(text) {
      return Scrollbar(
        // thumbVisibility: true,
        controller: _controllerOne,
        thickness: 6,
        child: SingleChildScrollView(
          controller: _controllerOne,
          child: Container(
            padding: EdgeInsets.all(getH(context, 2)),
            child: Text(text, style: const TextStyle(fontSize: 16),),
          ),
        ),
      );
    }

    // TabBarと詳細内容のWidget
    final cardDetailInfo = DefaultTabController(
      length: 3, // タブの個数
      initialIndex: 0,
      child: Container(
        width: getW(context, 95),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textIconColor, width: 0.6)
        ),
        child: Column(
          children: [
            // TabBar
            Container(
              margin: EdgeInsets.only(top: getW(context, 2), left: getW(context, 2), right: getW(context, 2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]
              ),
              child: cardInfoTabBar,
            ),
            // カードの詳細情報
            SizedBox(
              height: getH(context, 20),  // TabBarViewの高さ
              child: TabBarView(
                children: [
                  singleCardDetailInfo(card["distribute_place"]!),
                  singleCardDetailInfo(card["distribute_time"]!),
                  singleCardDetailInfo(card["issue_date"]!),
                ]
              ),
            )
          ]
        ),
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(  // 幅を設定しないとcenterにならない
          width: getW(context, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
            children: [
              Image.asset(
                  width: getW(context, 10),
                  height: getH(context, 10),
                  'images/AppBar_logo.png'
              ),
              const Text("Manhole Card"),
            ]
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings/setting_page');
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
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
                  CarouselSliderPhotos(imgList: imgList),
                  SizedBox(height: getW(context, 1)),
                  // カード番号・都道府県・市町村
                  Column(
                    children: [
                      Text(
                        "第${card["version"]!}弾",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card["card_number"]!,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          /// お気に入り登録していたら以下の2行を追加
                          if (bookmark) ... {
                            SizedBox(width: getW(context, 1)),
                            const Icon(Icons.bookmark_rounded, color: textIconColor)
                          }
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${card["prefecture"]!} ${card["city"]!}",
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      )
                    ]
                  ),
                  SizedBox(height: getW(context, 3)),
                  //  配布場所・配布時間・発行日
                  cardDetailInfo,
                  SizedBox(height: getW(context, 3)),
                  //  収集日とお気に入りマーク
                  const Text('収集日: $collectionDay', style: TextStyle(fontSize: 16)),
                  //  配布状況ボタン
                  WhiteButton(
                    text: '配布状況',
                    fontSize: 16,
                    onPressed: () {
                      _launchInBrowser(toLaunch);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: getH(context, 6),
            color: textIconColor,
            child: IconButton(
              onPressed: () {
                context.push('/cards/my_card_edit_page');
              },
              icon: const Icon(Icons.edit_rounded),
              iconSize: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}