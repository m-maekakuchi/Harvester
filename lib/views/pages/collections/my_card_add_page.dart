import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_color.dart';
import '../../../commons/image_num_per_card.dart';
import '../../../handlers/padding_handler.dart';
import '../../../viewModels/card_master_option_view_model.dart';
import '../../../viewModels/image_view_model.dart';
import '../../components/card_master_option_list_view.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/title_container.dart';
import '../../widgets/bookmark_button.dart';
import '../../widgets/green_button.dart';
import '../../components/user_select_item_container.dart';
import '../../components/white_show_modal_bottom_sheet.dart';

final cardIndexProvider = StateProvider((ref) => 0);
final dateProvider = StateProvider((ref) => DateTime.now());
// trueならお気に入り登録する
final bookmarkProvider = StateProvider((ref) => false);

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final cardIndex = ref.watch(cardIndexProvider);
    final date = ref.watch(dateProvider);

    final cardMasterOptionList = ref.watch(cardMasterOptionListProvider);
    final imageList = ref.watch(imageListProvider);

    /// マスターカード選択欄のリスト
    // Widget cardMasterOptionListView() {
    //   return ListView.builder(
    //     itemCount: cardMasterOptionList.length,
    //     itemBuilder: (context, index) {
    //       return GestureDetector(
    //         onTap: () {
    //           final cardIndexNotifier = ref.read(cardIndexProvider.notifier);
    //           cardIndexNotifier.state = index;
    //           context.pop();
    //         },
    //         child: Container(
    //           alignment: Alignment.centerLeft,
    //           padding: EdgeInsets.only(left: getW(context, 5)),
    //           decoration: const BoxDecoration(
    //             border: Border(
    //               bottom: BorderSide(color: textIconColor, width: 0.1),
    //             ),
    //           ),
    //           height: getH(context, 6),
    //           child: Text(cardMasterOptionList[index]),
    //         ),
    //       );
    //     },
    //   );
    // }

    /// 日付のPickerを表示
    Future<DateTime?> showDate(date) {
      return showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: themeColor,      /// ヘッダー背景色
                onPrimary: textIconColor, /// ヘッダーテキストカラー
                onSurface: textIconColor, /// カレンダーのテキストカラー
              ),
              textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(textIconColor), // ボタンの色
                ),
              ),
            ),
            child: child!,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
            width: getW(context, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
              children: [
                Image.asset(
                  width: getW(context, 10),
                  height: getH(context, 10),
                  'images/AppBar_logo.png'
                ),
                const Text("My Card 追加"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getH(context, 3)),
            /// 写真選択欄
            for (var i = 0; i < imageNumPerCard / 2; i++) ... {
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var j = 0; j < 2; j++) ... {
                    PickAndCropImageContainer(index: i * 2 + j),
                  },
                ]
              ),
            },
            const TitleContainer(titleStr: 'カード'),
            /// カード選択欄
            UserSelectItemContainer(
              text: cardMasterOptionList[cardIndex],
              onPressed: () {
                whiteShowModalBottomSheet(
                  context: context,
                  child: cardMasterOptionListView(
                    list: cardMasterOptionList,
                    ref: ref,
                    provider: cardIndexProvider
                  ),
                );
              },
            ),
            const TitleContainer(titleStr: '収集日'),
            /// 収集日選択欄
            UserSelectItemContainer(
              text: '${date.year}/${date.month}/${date.day}',
              onPressed: () async {
                final selectedDate = await showDate(date);
                // 日付が選択された場合
                if (selectedDate != null) {
                  final notifier = ref.read(dateProvider.notifier);
                  notifier.state = selectedDate;
                }
              },
            ),
            SizedBox(height: getH(context, 2)),
            /// お気に入り選択
            BookMarkButton(provider: bookmarkProvider),
            SizedBox(height: getH(context, 2),),
            GreenButton(
              text: '登録',
              fontSize: 18,
              onPressed: imageList.isEmpty
                ? null
                : () {
                  ref.read(imageListProvider.notifier).uploadImageToFirebase(); /// 画像をstorageに登録
                },
            ),
          ]
        ),
      ),
    );
  }

}