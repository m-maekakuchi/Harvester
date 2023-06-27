import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_color.dart';
import '../../../commons/image_num_per_card.dart';
import '../../../commons/message.dart';
import '../../../handlers/padding_handler.dart';
import '../../../repositories/local_storage_repository.dart';
import '../../../viewModels/image_view_model.dart';
import '../../components/accordion_card_masters.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/title_container.dart';
import '../../widgets/bookmark_button.dart';
import '../../widgets/green_button.dart';
import '../../components/user_select_item_container.dart';
import '../../components/white_show_modal_bottom_sheet.dart';

final cardProvider = StateProvider((ref) => noSelectOption);
final dateProvider = StateProvider((ref) => DateTime.now());
// trueならお気に入り登録する
final bookmarkProvider = StateProvider((ref) => false);

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectCard = ref.watch(cardProvider);
    final date = ref.watch(dateProvider);
    final imageList = ref.watch(imageListProvider);

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
        child: FutureBuilder<Map<String, List<String>>?>(
          future: LocalStorageRepository().fetchCardMasterOptionMap(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              final error  = snapshot.error;
              return Text('$error', style: TextStyle(fontSize: 60,),);
            } else if (snapshot.hasData) {
              Map<String, List<String>> result = snapshot.data!;
              return Column(
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
                    text: selectCard,
                    onPressed: () {
                      whiteShowModalBottomSheet(
                        context: context,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                          ),
                          height: getH(context, 90),
                          child: AccordionCardMasters(
                            provider: cardProvider,
                            cardMasterMap: result,
                          ),
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
                    onPressed: imageList.isEmpty || selectCard == noSelectOption
                      ? null
                      : () {
                      // 画像をstorageに登録
                      ref.read(imageListProvider.notifier).uploadImageToFirebase();
                    },
                  ),
                ]
              );
            } else {
              return const Text("しばらくお待ち下さい", style: TextStyle(fontSize: 30,),);
            }
          }
        ),
      ),
    );
  }

}