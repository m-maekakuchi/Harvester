import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/app_const.dart';
import '../../../commons/message.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/card_master_model.dart';
import '../../../models/card_model.dart';
import '../../../models/image_model.dart';
import '../../../provider/providers.dart';
import '../../../viewModels/image_view_model.dart';
import '../../components/date_picker.dart';
import '../../components/error_body.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/shimmer_loading_card_detail.dart';
import '../../widgets/bookmark_button.dart';
import '../../components/title_container.dart';
import '../../components/user_select_item_container.dart';
import '../../widgets/done_message_dialog.dart';
import '../../widgets/modal_barrier.dart';

class MyCardEditPage extends ConsumerWidget {
  final CardMasterModel cardMasterModel;
  final CardModel cardModel;
  final List<ImageModel> preImageModelList;

  const MyCardEditPage({
    super.key,
    required this.cardMasterModel,
    required this.cardModel,
    required this.preImageModelList,
  });

  Future<void> getData(WidgetRef ref) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final popContext = context; // 変更完了のダイアログを閉じるときにcontextだとエラーになるのでこれを追加
    final cardEditState = ref.watch(cardEditStateProvider); // 削除処理の状況を監視
    final loadingState = ref.watch(loadingIndicatorProvider);
    final appBarColorIndex = ref.watch(colorProvider);

    final imageModelList = ref.watch(imageListProvider);
    final selectedCollectDay = ref.watch(cardEditPageCollectDayProvider);

    final bodyWidget = FutureBuilder(
      future: getData(ref),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoadingCardDetail();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Column(
            children: [
              Expanded( //　ボタンを下部に固定するために、それ以外のWidgetをExpandedで囲む
                child: SingleChildScrollView(
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
                      /// 取得カードの選択欄
                      Container(
                        width: getW(context, 90),
                        margin: EdgeInsets.only(bottom: getH(context, 1)),
                        decoration: BoxDecoration(
                          color: isDarkMode ? darkModeBackgroundColor : scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CupertinoButton( // TextIconでもいいけど日付選択欄のボタンにあわせてデザイン揃えている
                          padding: EdgeInsets.symmetric(
                            horizontal: getW(context, 5)),
                          onPressed: () {},
                          child: SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${cardMasterModel.serialNumber}　${cardMasterModel.city}",
                                style: TextStyle(color: isDarkMode ? Colors.white : textIconColor),
                                maxLines: 1,
                              )
                            ),
                          ),
                        ),
                      ),
                      const TitleContainer(titleStr: '収集日'),
                      /// 収集日選択欄
                      UserSelectItemContainer(
                        text: convertDateTimeToString(selectedCollectDay),
                        onPressed: () async {
                          final selectedDayFromCalendar = await DatePicker(context: context, colorIndex: appBarColorIndex).showDate(selectedCollectDay);
                          // 日付が選択された場合
                          if (selectedDayFromCalendar != null) {
                            ref.read(cardEditPageCollectDayProvider.notifier).state = selectedDayFromCalendar;
                          }
                        },
                      ),
                      SizedBox(height: getH(context, 2)),
                      /// お気に入り登録設定
                      BookMarkButton(provider: cardEditPageFavoriteProvider),
                      SizedBox(height: getH(context, 2)),
                    ],
                  ),
                ),
              ),
              /// 編集完了ボタンと削除ボタン
              Container(
                width: double.infinity,
                height: getH(context, 10),
                color: isDarkMode ? Colors.black : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // doneボタン
                    IconButton(
                      //  画像を1つも選択していない、編集又は削除の処理中の場合はボタンを押せないようにする
                      onPressed: imageModelList.isNotEmpty && !loadingState
                        ? () async {
                          ref.read(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする

                          await ref.read(cardEditProvider).update(cardMasterModel, cardModel, preImageModelList);

                          // 最後まで削除処理ができた場合（cardRemoveStateがloadingやerrorではないとき）
                          if (ref.read(cardEditStateProvider).value == null) {  // watchだと全部nullになる…
                            Future.delayed(   // 1秒後にダイアログを閉じる
                              const Duration(seconds: 1),
                              () {
                                popContext.pop();
                                ref.read(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                                // 一覧画面まで戻る
                                if (popContext.mounted) popContext.pop();
                                if (popContext.mounted) popContext.pop();
                                // ホーム画面に切り替える
                                ref.read(bottomBarIndexProvider.notifier).state = 0;
                              }
                            );
                            // 登録完了のダイアログを表示
                            if (popContext.mounted) doneMessageDialog(popContext, registerCompleteMessage);
                          }
                        }
                        : null,
                      icon: const Icon(Icons.done_rounded),
                      iconSize: 40,
                      color: isDarkMode ? Colors.white : textIconColor,
                    ),
                    // 削除ボタン
                    IconButton(
                      //  編集又は削除の処理中の場合はボタンを押せないようにする
                      onPressed: !loadingState
                        ? () async {
                          ref.read(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする

                          // カードの削除処理
                          await ref.read(cardEditProvider).remove(cardMasterModel, preImageModelList);

                          // 最後まで削除処理ができた場合（cardRemoveStateがloadingやerrorではないとき）
                          if (ref.read(cardEditStateProvider).value == null) {  // watchだと全部nullになる…
                            Future.delayed(   // 1秒後にダイアログを閉じる
                              const Duration(seconds: 1),
                              () {
                                popContext.pop();
                                ref.read(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                                // 一覧画面まで戻る
                                if (popContext.mounted) popContext.pop();
                                if (popContext.mounted) popContext.pop();
                                // ホーム画面に切り替える
                                ref.read(bottomBarIndexProvider.notifier).state = 0;
                              }
                            );
                            // 登録完了のダイアログを表示
                            if (popContext.mounted) doneMessageDialog(popContext, deleteCompleteMessage);
                          }
                        }
                      : null,
                      icon: const Icon(Icons.delete_rounded),
                      iconSize: 40,
                      color: isDarkMode ? Colors.white : textIconColor,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: titleBox('My Card 編集', context),
        actions: actionList(context),
        backgroundColor: themeColorChoice[appBarColorIndex],
      ),
      body: cardEditState.when(
        data: (value) {
          return bodyWidget;
        },
        error: (err, _) {
          return ErrorBody(
            errMessage: undefinedErrorMessage,
            onPressed: () {
              final notifier = ref.read(cardEditStateProvider.notifier);
              notifier.state = const AsyncValue.data(null);
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
