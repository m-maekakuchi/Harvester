import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../handlers/padding_handler.dart';
import '../../components/accordion_prefectures.dart';
import '../../components/white_show_modal_bottom_sheet.dart';
import '../../widgets/white_button.dart';

final prefectureProvider = StateProvider((ref) => "");

// MyCardの登録がない場合に表示させるメッセージ
const noMyCardsMsg = Text(
  'My Card はありません'
);

class MyCardsListPage extends ConsumerWidget {
  const MyCardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPrefecture = ref.watch(prefectureProvider);

    //  日付タブのbody
    final body0 = SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: getW(context, 5), top: getH(context, 2), bottom: getH(context, 1)),
            width: double.infinity,
            child: const Text(
              "2023年5月1日",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // const CardShortInfoContainer(
          //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //   city: "札幌市（A001）",
          //   version: 1,
          //   serialNumber: "01-100-A001",
          // ),
          // const CardShortInfoContainer(
          //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //   city: "札幌市（B001）",
          //   version: 9,
          //   serialNumber: "01-100-B001",
          // ),
          Container(
            padding: EdgeInsets.only(left: getW(context, 5), top: getH(context, 2), bottom: getH(context, 1)),
            width: double.infinity,
            child: const Text(
              "2023年4月23日",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // const CardShortInfoContainer(
          //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //   city: "札幌市（A001）",
          //   version: 1,
          //   serialNumber: "01-100-A001",
          // ),
          // const CardShortInfoContainer(
          //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //   city: "札幌市（B001）",
          //   version: 9,
          //   serialNumber: "01-100-B001",
          // ),
        ],
      ),
    );

    // お気に入りタブのbody
    final body1 = SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: getH(context, 2),),
          //       const CardShortInfoContainer(
          //         image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //         city: "札幌市（A001）",
          //         version: 1,
          //         serialNumber: "01-100-A001",
          //       ),
          //       const CardShortInfoContainer(
          //         image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //         city: "札幌市（B001）",
          //         version: 9,
          //         serialNumber: "01-100-B001",
          //       ),
        ],
      ),
    );

    // 全国タブのbody
    final body2 = SingleChildScrollView(
      child: Column(
        children: [
          //       Container(
          //         padding: EdgeInsets.only(left: getW(context, 5), top: getH(context, 2), bottom: getH(context, 1)),
          //         width: double.infinity,
          //         child: const Text(
          //           "北海道",
          //           textAlign: TextAlign.left,
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ),
          //       const CardShortInfoContainer(
          //         image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //         city: "札幌市（A001）",
          //         version: 1,
          //         serialNumber: "01-100-A001",
          //       ),
          //       const CardShortInfoContainer(
          //         image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //         city: "札幌市（B001）",
          //         version: 9,
          //         serialNumber: "01-100-B001",
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: getW(context, 5), top: getH(context, 2), bottom: getH(context, 1)),
          //         width: double.infinity,
          //         child: const Text(
          //           "青森県",
          //           textAlign: TextAlign.left,
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ),
          //       const CardShortInfoContainer(
          //         image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
          //         city: "青森市",
          //         version: 5,
          //         serialNumber: "02-201-A001",
          //       ),
        ],
      ),
    );

    // 都道府県タブのbody
    final body3 = SingleChildScrollView(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: getW(context, 5), vertical: getH(context, 1)),
              width: double.infinity,
              child: Text(
                selectedPrefecture,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "札幌市（A001）",
            //   version: 1,
            //   serialNumber: "01-100-A001",
            // ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "札幌市（B001）",
            //   version: 9,
            //   serialNumber: "01-100-B001",
            // ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "函館市",
            //   version: 3,
            //   serialNumber: "01-202-B001",
            // ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "小樽市",
            //   version: 3,
            //   serialNumber: "01-203-B001",
            // ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "旭川市",
            //   version: 4,
            //   serialNumber: "01-204-B001",
            // ),
            // const CardShortInfoContainer(
            //   image: 'https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1',
            //   city: "室蘭市",
            //   version: 8,
            //   serialNumber: "01-205-B001",
            // ),
          }
        ],
      ),
    );

    return Scaffold(
      body: TabBarView(
        children: [
          body0,
          body1,
          body2,
          body3,
        ]
      ),
    );
  }
}