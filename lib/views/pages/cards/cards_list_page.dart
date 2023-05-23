import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../components/CardShortInfoContainer.dart';
import '../../widgets/RegionAccordion.dart';
import '../../components/ColoredTabBar.dart';

const List<Tab> tabs = [
  Tab(text: '全国'),
  Tab(text: '都道府県'),
];

final prefectureProvider = StateProvider((ref) => "");

class CardsListPage extends ConsumerWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPrefecture = ref.watch(prefectureProvider);

    // 「全国」タブのbody
    final tabBody0 = SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: getW(context, 5), vertical: getH(context, 1)),
            width: double.infinity,
            child: const Text(
              "北海道",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "札幌市（A001）",
            version: 1,
            serialNumber: "01-100-A001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "札幌市（B001）",
            version: 9,
            serialNumber: "01-100-B001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "函館市",
            version: 3,
            serialNumber: "01-202-B001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "小樽市",
            version: 3,
            serialNumber: "01-203-B001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "旭川市",
            version: 4,
            serialNumber: "01-204-B001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "室蘭市",
            version: 8,
            serialNumber: "01-205-B001",
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: getW(context, 5), vertical: getH(context, 1)),
            width: double.infinity,
            child: const Text(
              "青森県",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "青森市",
            version: 5,
            serialNumber: "02-201-A001",
          ),
          const CardInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "弘前市",
            version: 9,
            serialNumber: "02-202-B001",
          ),
        ],
      ),
    );

    //  都道府県の選択column
    final columnSelectPrefectures = Column(
      children: [
        Container(
            height: getH(context, 6),
            alignment: Alignment.center,
            child: const Text("都道府県の選択", style: TextStyle(fontSize: 16),)
        ),
        Expanded( // スクロールさせる領域をExpandedで囲むと、それ以外が固定になる
          child: SingleChildScrollView(
            child: Column(
              children: [
                RegionAccordion(
                  title: '北海道',
                  listTitleAry: const [
                    '北海道'
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '東北',
                  listTitleAry: const [
                    '青森県',
                    '岩手県',
                    '宮城県',
                    '秋田県',
                    '山形県',
                    '福島県',
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '関東',
                  listTitleAry: const [
                    '茨城県',
                    '栃木県',
                    '群馬県',
                    '埼玉県',
                    '千葉県',
                    '東京都',
                    '神奈川県',
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '中部',
                  listTitleAry: const [
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
                  ref: ref,
                ),
                RegionAccordion(
                  title: '近畿',
                  listTitleAry: const [
                    '三重県',
                    '滋賀県',
                    '京都府',
                    '大阪府',
                    '兵庫県',
                    '奈良県',
                    '和歌山県',
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '中国',
                  listTitleAry: const [
                    '鳥取県',
                    '島根県',
                    '岡山県',
                    '広島県',
                    '山口県',
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '四国',
                  listTitleAry: const [
                    '徳島県',
                    '香川県',
                    '愛媛県',
                    '高知県',
                  ],
                  ref: ref,
                ),
                RegionAccordion(
                  title: '九州',
                  listTitleAry: const [
                    '福岡県',
                    '佐賀県',
                    '長崎県',
                    '熊本県',
                    '大分県',
                    '宮崎県',
                    '鹿児島県',
                    '沖縄県',
                  ],
                  ref: ref,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // 「都道府県」タブのbody
    final tabBody1 = SingleChildScrollView(
      child: Column(
        children: [
          // 都道府県選択ボタン
          Container(
            width: getW(context, 60),
            height: getH(context, 5),
            margin: EdgeInsets.symmetric(vertical: getH(context, 2)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: indicatorBeginColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)
                )
              ),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,  // ModalBottomSheetを角丸にするための設定
                  isScrollControlled: true, // ModalBottomSheetの画面を半分以上にできる
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                      height: getH(context, 90),
                      child: columnSelectPrefectures,
                    );
                  }
                );
              },
              child: const Text(
                '都道府県の選択',
                style: TextStyle(
                  fontSize: 16,
                )
              ),
            ),
          ),
          // 都道府県を選択したら以下が表示される
          if (selectedPrefecture != "") ... {
            Container(
              padding: EdgeInsets.symmetric(horizontal: getW(context, 5), vertical: getH(context, 1)),
              width: double.infinity,
              child: Text(
                selectedPrefecture,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "札幌市（A001）",
              version: 1,
              serialNumber: "01-100-A001",
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "札幌市（B001）",
              version: 9,
              serialNumber: "01-100-B001",
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "函館市",
              version: 3,
              serialNumber: "01-202-B001",
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "小樽市",
              version: 3,
              serialNumber: "01-203-B001",
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "旭川市",
              version: 4,
              serialNumber: "01-204-B001",
            ),
            const CardInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "室蘭市",
              version: 8,
              serialNumber: "01-205-B001",
            ),
          }
        ],
      ),
    );

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        // タブを切り替えたときに呼び出される
        tabController.addListener(() {});
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