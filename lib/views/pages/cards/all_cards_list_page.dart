import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/card_short_info_container.dart';
import '../../components/accordion_prefectures.dart';
import '../../components/colored_tab_bar.dart';
import '../../components/white_show_modal_bottom_sheet.dart';
import '../../widgets/white_button.dart';

const List<Tab> tabs = [
  Tab(text: '全国'),
  Tab(text: '都道府県'),
];

final prefectureProvider = StateProvider((ref) => "");

// final cardMasterControllerProvider = StateNotifierProvider<CardMasterViewModel, List<CardMasterModel>>((ref) {
//   return CardMasterViewModel(CardMasterRepository());
// });

class AllCardsListPage extends ConsumerWidget {
  const AllCardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPrefecture = ref.watch(prefectureProvider);
    // final List<CardMasterModel> cardMasterList = ref.watch(cardMasterControllerProvider);

    // 「全国」タブのbody
    final tabBody0 = SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: getH(context, 2),),
          // for (var data in cardMasterList) ... {
          //   CardShortInfoContainer(
          //     image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //     prefecture: "${data.prefecture}",
          //     city: "${data.city}",
          //     version: data.version,
          //     serialNumber: "${data.serialNumber}",
          //   ),
          // }
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
              showWhiteModalBottomSheet(
                context: context,
                widget: AccordionPrefectures(
                  provider: prefectureProvider,
                )
              );
            },
          ),

          // 都道府県を選択したら以下が表示される
          if (selectedPrefecture != "") ... {
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              prefecture: "北海道",
              city: "札幌市（A001）",
              version: 1,
              serialNumber: "01-100-A001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              prefecture: "北海道",
              city: "札幌市（B001）",
              version: 9,
              serialNumber: "01-100-B001",
            ),
            const CardShortInfoContainer(
              image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
              prefecture: "北海道",
              city: "函館市",
              version: 3,
              serialNumber: "01-202-B001",
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
        tabController.addListener(() async {

        });
        return Scaffold(
          appBar: AppBar(
            title: SizedBox(
              width: getW(context, 60),
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