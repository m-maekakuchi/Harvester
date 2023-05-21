import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../widgets/Accordion.dart';
import '../../components/ColoredTabBar.dart';

const List<Tab> tabs = [
  Tab(text: '全国'),
  Tab(text: '都道府県'),
];

// 「全国」タブのbody
final tabBody0 = const Text("aaaaaa");

// アコーディオンを縦に並べるカラム
final column = Column(
  children: const [
    Accordion(
      title: '北海道',
      listTitleAry: [
        '北海道'
      ],
    ),
    Accordion(
      title: '東北',
      listTitleAry: [
        '青森県',
        '岩手県',
        '宮城県',
        '秋田県',
        '山形県',
        '福島県',
      ],
    ),
    Accordion(
      title: '関東',
      listTitleAry: [
        '茨城県',
        '栃木県',
        '群馬県',
        '埼玉県',
        '千葉県',
        '東京都',
        '神奈川県',
      ],
    ),
    Accordion(
      title: '中部',
      listTitleAry: [
        '新潟県',
        '富山県',
        '石川県',
        '福井県',
        '山梨県',
        '長野県',
        '岐阜県',
        '静岡県',
        '愛知県',
      ],
    ),
    Accordion(
      title: '近畿',
      listTitleAry: [
        '三重県',
        '滋賀県',
        '京都府',
        '大阪府',
        '兵庫県',
        '奈良県',
        '和歌山県',
      ],
    ),
    Accordion(
      title: '中国',
      listTitleAry: [
        '鳥取県',
        '島根県',
        '岡山県',
        '広島県',
        '山口県',
      ],
    ),
    Accordion(
      title: '四国',
      listTitleAry: [
        '徳島県',
        '香川県',
        '愛媛県',
        '高知県',
      ],
    ),
    Accordion(
      title: '九州',
      listTitleAry: [
        '福岡県',
        '佐賀県',
        '長崎県',
        '熊本県',
        '大分県',
        '宮崎県',
        '鹿児島県',
        '沖縄県',
      ],
    ),
  ],
);

// 「都道府県」タブのbody
final tabBody1 = SingleChildScrollView(
  child: column,
);

class CardsListPage extends ConsumerWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        // final TabController tabController = DefaultTabController.of(context);
        // tabController.addListener(() {
        //   if (!tabController.indexIsChanging) {
        //     print(tabController.index);
        //   }
        // });
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: themeColor,
            foregroundColor: textIconColor,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
                children: [
                  Image.asset(
                    width: getW(context, 10),
                    height: getH(context, 10),
                    'images/AppBar_logo.png'
                  ),
                  const Text('All Manhole Cards'),
                ],
              ),
            ),
            iconTheme: const IconThemeData(
              size: 30,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/settings/setting_page');
                },
                icon: const Icon(
                  Icons.settings_rounded,
                  color: textIconColor,
                ),
              ),
            ],
            bottom: const ColoredTabBar(
              tabBar: TabBar(
                indicatorColor: textIconColor,
                labelColor: textIconColor,
                tabs: tabs,
              ),
              color: scaffoldBackgroundColor,
            ),
          ),
          body: TabBarView(
            children: [
              tabBody0,
              tabBody1,
            ]
          ),
        );
      }),
    );
  }
}