import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/provider/providers.dart';

import '../../../commons/address_master.dart';
import '../../../commons/app_color.dart';
import '../../../commons/message.dart';
import '../../widgets/message_dialog_two_actions.dart';
import '../../widgets/modal_barrier.dart';
import '../../widgets/text_message_dialog.dart';
import '../../widgets/done_message_dialog.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/user_info_model.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/user_view_model.dart';
import '../../components/title_container.dart';
import '../../widgets/green_button.dart';
import '../../components/user_select_item_container.dart';
import '../../widgets/item_cupertino_picker.dart';

// TextEditingControllerのtextでTextFormFieldの初期値を設定
final textControllerProvider = StateProvider((ref) =>
  TextEditingController(text: ref.read(userViewModelProvider).name)
);
final addressIndexProvider = StateProvider((ref) =>
  ref.read(userViewModelProvider).addressIndex
);
final birthdayProvider = StateProvider((ref) =>
  convertDateTimeToString(ref.read(userViewModelProvider).birthday!)
);

class UserInfoEditPage extends ConsumerWidget {
  const UserInfoEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textController = ref.watch(textControllerProvider);
    final selectedAddressIndex = ref.watch(addressIndexProvider);
    final selectedBirthday = ref.watch(birthdayProvider);

    final userUpdateState = ref.watch(userEditStateProvider);
    final loadingState = ref.read(loadingIndicatorProvider);
    final appBarColorIndex = ref.watch(colorProvider);

    // 居住地のドラムロール
    void showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: child,
            ),
          );
        }
      );
    }

    Widget bodyWidget = SingleChildScrollView(
      child: Column(
        children: [
          const TitleContainer(titleStr: 'ニックネーム'),
          //  ニックネーム欄
          SizedBox(
            width: getW(context, 90),
            height: getH(context, 6),
            child: TextFormField(
              controller: textController,
              // 入力されたテキストの色
              style: const TextStyle(
                  color: textIconColor
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                // 枠線の色
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: textIconColor,
                    width: 1,
                  ),
                ),
                // 入力中の枠線の色
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: textIconColor,
                    width: 1,
                  ),
                ),
                hintText: '10文字以内',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: textIconColor,
                ),
              ),
            ),
          ),
          const TitleContainer(titleStr: '居住地'),
          // 居住地選択欄
          UserSelectItemContainer(
            text: addressList[selectedAddressIndex!],
            onPressed: () => showDialog(
              ItemCupertinoPicker(
                itemAry: addressList,
                provider: addressIndexProvider,
              ),
            ),
          ),
          const TitleContainer(titleStr: '生年月日'),
          // 生年月日選択欄
          UserSelectItemContainer(
              text: selectedBirthday,
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: false,
                    minTime: DateTime(1950, 1, 1),
                    maxTime: DateTime(2020, 12, 31),
                    onChanged: (date) {
                      final notifier = ref.read(birthdayProvider.notifier);
                      notifier.state = '${date.year}/${date.month}/${date.day}';
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.jp
                );
              }
          ),
          SizedBox(height: getH(context, 3)),
          GreenButton(
            text: '更新',
            fontSize: 18,
            // ニックネームが入力されていない場合、ボタンを押せなくする
            onPressed: textController.text == "" || loadingState
              ? null
              : () async {
                // ニックネームが10文字より長い場合、ダイアログで警告
                if (textController.text.length > 10) {
                  await textMessageDialog(context, textOverErrorMessage);
                  return;
                }

                ref.watch(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする

                final userUid = ref.watch(authViewModelProvider.notifier).getUid();
                final birthday = convertStringToDateTime(selectedBirthday);
                final userInfoModel = UserInfoModel(
                  firebaseAuthUid: userUid,
                  name: textController.text,
                  addressIndex: selectedAddressIndex,
                  birthday: birthday,
                  updatedAt: DateTime.now(),
                );

                // ユーザー情報の更新処理（DBとローカル）
                await ref.read(userEditProvider).update(userInfoModel);

                // 最後まで更新処理ができた場合（loadingやerrorではないとき）
                if (ref.read(userEditStateProvider).value == null) {
                  Future.delayed(   // 1秒後にダイアログを閉じる
                    const Duration(seconds: 1),
                    () {
                      ref.read(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                      context.pop();
                    },
                  );
                  // 登録完了のダイアログを表示
                  if (context.mounted) await doneMessageDialog(context, registerCompleteMessage);

                  if (context.mounted) context.pop();
                }
              }
          ),
          SizedBox(height: getH(context, 3)),
          TextButton(
            // ニックネームが入力されていない場合、ボタンを押せなくする
            onPressed: loadingState
              ? null
              : () {
                messageDialogTwoActions(
                  context,
                  deleteAuthMessage,
                  const Text(deleteAuthAlertMessage),
                  dialogPopText,
                  dialogDeleteAuthPushText,
                  () async {
                    ref.watch(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする
                    context.pop();
                    // ユーザー全データの削除処理
                    await ref.watch(userEditProvider).delete();

                    // 最後まで削除処理ができた場合（loadingやerrorではないとき）
                    if (ref.read(userEditStateProvider).value == null) {
                      await ref.watch(authViewModelProvider.notifier).delete();
                      ref.watch(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                      await ref.watch(authViewModelProvider.notifier).signOut();
                    }
                  }
                );
              },
            child: const Text(
              '退会',
              style: TextStyle(
                fontSize: 18,
                color: textIconColor,
              )
            ),
          )
        ],
      ),
    );

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 戻るボタンを押した場合、編集情報は初期値に戻す
              // 次にまた編集画面開いたときに編集途中の情報が表示されると、それが登録されていると勘違いさせてしまいそう
              ref.read(textControllerProvider.notifier).state = TextEditingController(text: ref.read(userViewModelProvider).name);
              ref.read(addressIndexProvider.notifier).state = ref.read(userViewModelProvider).addressIndex;
              ref.read(birthdayProvider.notifier).state = convertDateTimeToString(ref.read(userViewModelProvider).birthday!);
              context.pop();
            },
          ),
          title: SizedBox(  // 幅を設定しないとcenterにならない
            width: getW(context, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
              children: [
                Image.asset(
                  width: getW(context, 10),
                  height: getH(context, 10),
                  'images/AppBar_logo.png'
                ),
                const Text("アカウント編集", style: TextStyle(fontSize: 18)),
              ]
            ),
          ),
          backgroundColor: themeColorChoice[appBarColorIndex],
        ),
        body: userUpdateState.when(
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
        ),
      ),
    );
  }

}