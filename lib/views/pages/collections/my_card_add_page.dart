import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_const_num.dart';
import '../../../commons/message.dart';
import '../../../viewModels/card_view_model.dart';
import '../../../viewModels/image_view_model.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/date_picker.dart';
import '../../widgets/done_message_dialog.dart';
import '../../components/accordion_card_masters.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/title_container.dart';
import '../../components/user_select_item_container.dart';
import '../../components/white_show_modal_bottom_sheet.dart';
import '../../widgets/bookmark_button.dart';
import '../../widgets/green_button.dart';
import '../../widgets/modal_barrier.dart';

final cardProvider = StateProvider((ref) => noSelectOptionMessage);
final dateProvider = StateProvider((ref) => DateTime.now());
final bookmarkProvider = StateProvider((ref) => false);

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedCard = ref.watch(cardProvider);
    final selectedDay = ref.watch(dateProvider);
    final selectedImageList = ref.watch(imageListProvider);
    final bookmark = ref.watch(bookmarkProvider);

    AsyncValue<bool> cardAddState = ref.watch(cardViewModelProvider);

    Widget bodyWidget = SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: getH(context, 3)),
          // 写真選択欄
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
          // カード選択欄
          UserSelectItemContainer(
            text: selectedCard,
            onPressed: () {
              showWhiteModalBottomSheet(
                context: context,
                widget: AccordionCardMasters(
                  provider: cardProvider,
                ),
              );
            },
          ),
          const TitleContainer(titleStr: '収集日'),
          // 収集日選択欄
          UserSelectItemContainer(
            text: '${selectedDay.year}/${selectedDay.month}/${selectedDay.day}',
            onPressed: () async {
              final selectedDayFromCalendar = await DatePicker(context: context).showDate(selectedDay);
              // 日付が選択された場合
              if (selectedDayFromCalendar != null) {
                final notifier = ref.read(dateProvider.notifier);
                notifier.state = selectedDayFromCalendar;
              }
            },
          ),
          SizedBox(height: getH(context, 2)),
          // お気に入り選択
          BookMarkButton(provider: bookmarkProvider),
          SizedBox(height: getH(context, 2),),
          GreenButton(
            text: '登録',
            fontSize: 18,
            onPressed: selectedImageList.isEmpty || selectedCard == noSelectOptionMessage
              ? null
              : () async {
                // var box = await Hive.openBox('cardBox');
                // box.delete("myCardNumber");
                // return;

                await ref.watch(cardViewModelProvider.notifier).cardAdd(selectedCard, selectedImageList, selectedDay, bookmark, ref, context);
                if (ref.read(cardViewModelProvider).value != false) {  // 最後まで登録処理ができた場合
                  // プロバイダをリセット
                  await ref.read(imageListProvider.notifier).init();
                  ref.read(cardProvider.notifier).state = noSelectOptionMessage;
                  ref.read(dateProvider.notifier).state = DateTime.now();
                  ref.read(bookmarkProvider.notifier).state = false;

                  Future.delayed(   // 1秒後にダイアログを閉じる
                    const Duration(seconds: 1),
                    () => context.pop(),
                  );
                  // 登録完了のダイアログを表示
                  if (context.mounted) await doneMessageDialog(context);
                }
            },
          ),
        ]
      ),
    );

    return Scaffold(
      body: cardAddState.when(
        data: (value) {
          return bodyWidget;
        },
        error: (err, _) {
          return Center(child: Text(err.toString()));
        },
        loading: () {
          return Stack(
            children: [
              bodyWidget,
              modalBarrier
            ]
          );
        }
      )
    );
  }

}