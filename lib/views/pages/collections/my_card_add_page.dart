import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/app_const.dart';
import '../../../commons/message.dart';
import '../../../provider/providers.dart';
import '../../../viewModels/image_view_model.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/date_picker.dart';
import '../../components/error_body.dart';
import '../../widgets/done_message_dialog.dart';
import '../../components/accordion_card_masters.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/title_container.dart';
import '../../components/user_select_item_container.dart';
import '../../components/white_show_modal_bottom_sheet.dart';
import '../../widgets/bookmark_button.dart';
import '../../widgets/green_button.dart';
import '../../widgets/modal_barrier.dart';

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final cardAddState = ref.watch(cardAddStateProvider);

    final selectedCard = ref.watch(cardAddPageCardProvider);
    final selectedDay = ref.watch(cardAddPageCollectDayProvider);
    final selectedImageList = ref.watch(imageListProvider);
    final appBarColorIndex = ref.watch(colorProvider);

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
                  provider: cardAddPageCardProvider,
                ),
              );
            },
          ),
          const TitleContainer(titleStr: '収集日'),
          // 収集日選択欄
          UserSelectItemContainer(
            text: '${selectedDay.year}/${selectedDay.month}/${selectedDay.day}',
            onPressed: () async {
              final selectedDayFromCalendar = await DatePicker(context: context, colorIndex: appBarColorIndex).showDate(selectedDay);
              // 日付が選択された場合
              if (selectedDayFromCalendar != null) {
                final notifier = ref.read(cardAddPageCollectDayProvider.notifier);
                notifier.state = selectedDayFromCalendar;
              }
            },
          ),
          SizedBox(height: getH(context, 2)),
          // お気に入り選択
          BookMarkButton(provider: cardAddPageFavoriteProvider),
          SizedBox(height: getH(context, 2)),
          GreenButton(
            text: '登録',
            fontSize: 18,
            onPressed: selectedImageList.isEmpty || selectedCard == noSelectOptionMessage
              ? null
              : () async {
                // LocalStorageRepository().deleteMyCardIdAndFavorites();
                // return;
                ref.read(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする

                await ref.watch(cardAddProvider).cardAdd(context);
                if (ref.read(cardAddStateProvider).value == true) {  // 最後まで登録処理ができた場合
                  // プロバイダをリセット
                  await ref.read(imageListProvider.notifier).init();
                  ref.read(cardAddPageCardProvider.notifier).state = noSelectOptionMessage;
                  ref.read(cardAddPageCollectDayProvider.notifier).state = DateTime.now();
                  ref.read(cardAddPageFavoriteProvider.notifier).state = false;

                  Future.delayed(   // 1秒後にダイアログを閉じる
                    const Duration(seconds: 1),
                    () {
                      ref.read(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                      context.pop();
                    },
                  );
                  // 登録完了のダイアログを表示
                  if (context.mounted) await doneMessageDialog(context, registerCompleteMessage);
                }
            },
          ),
        ]
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: titleBox(pageTitleList[3], context),
        actions: actionList(context),
        backgroundColor: themeColorChoice[appBarColorIndex],
      ),
      body: cardAddState.when(
        data: (value) {
          return bodyWidget;
        },
        error: (err, _) {
          return ErrorBody(
            errMessage: undefinedErrorMessage,
            onPressed: () {
              final notifier = ref.read(cardAddStateProvider.notifier);
              notifier.state = const AsyncValue.data(false);
              ref.read(loadingIndicatorProvider.notifier).state = false;
            },
          );
        },
        loading: () {
          return Stack(
            children: [
              bodyWidget,
              modalBarrier
            ]
          );
        }
      ),
    );
  }

}