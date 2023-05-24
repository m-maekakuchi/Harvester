import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../components/CardShortInfoContainer.dart';
import '../../components/ColumnAccordionPrefecture.dart';
import '../../components/ColoredTabBar.dart';
import '../../widgets/WhiteButton.dart';

const List<Tab> tabs = [
  Tab(text: '全国'),
  Tab(text: '都道府県'),
];

final prefectureProvider = StateProvider((ref) => "");

class AllCardsListPage extends ConsumerWidget {
  const AllCardsListPage({super.key});

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
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "札幌市（A001）",
            version: 1,
            serialNumber: "01-100-A001",
          ),
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "札幌市（B001）",
            version: 9,
            serialNumber: "01-100-B001",
          ),
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "函館市",
            version: 3,
            serialNumber: "01-202-B001",
          ),
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "小樽市",
            version: 3,
            serialNumber: "01-203-B001",
          ),
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "旭川市",
            version: 4,
            serialNumber: "01-204-B001",
          ),
          const CardShortInfoContainer(
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
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "青森市",
            version: 5,
            serialNumber: "02-201-A001",
          ),
          const CardShortInfoContainer(
            image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            city: "弘前市",
            version: 9,
            serialNumber: "02-202-B001",
          ),
        ],
      ),
    );

    // 「都道府県」タブのbody
    final tabBody1 = SingleChildScrollView(
      child: Column(
        children: [
          // 都道府県選択ボタン
          WhiteButton(
            text: '都道府県の選択',
            fontSize: 16,
            onPressed: () {
              // 都道府県の選択のためのModalBottomSheetを出す
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
                    child: ColumnAccordionPrefectures(
                      ref: ref,
                      provider: prefectureProvider,
                    ),
                  );
                }
              );
            },
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
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "札幌市（A001）",
              version: 1,
              serialNumber: "01-100-A001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "札幌市（B001）",
              version: 9,
              serialNumber: "01-100-B001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "函館市",
              version: 3,
              serialNumber: "01-202-B001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "小樽市",
              version: 3,
              serialNumber: "01-203-B001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              city: "旭川市",
              version: 4,
              serialNumber: "01-204-B001",
            ),
            const CardShortInfoContainer(
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
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
                children: [
                  Image.asset(
                    width: getW(context, 10),
                    height: getH(context, 10),
                    'images/AppBar_logo.png'
                  ),
                  const Text("All Manhole Cards"),
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