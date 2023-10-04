import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/address_master.dart';
import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/message.dart';
import '../../../provider/providers.dart';
import '../../../models/user_info_model.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/title_container.dart';
import '../../components/user_select_item_container.dart';
import '../../widgets/green_button.dart';
import '../../widgets/modal_barrier.dart';
import '../../widgets/item_cupertino_picker.dart';
import '../../widgets/text_message_dialog.dart';

final textControllerProvider = StateProvider((ref) => TextEditingController());
final addressProvider = StateProvider((ref) => 12);
final birthdayProvider = StateProvider((ref) => noSelectOptionMessage);

class UserInfoRegisterPage extends ConsumerWidget {
  const UserInfoRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final textController = ref.watch(textControllerProvider);
    final selectedAddressIndex = ref.watch(addressProvider);
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
          Container(
            width: getW(context, 90),
            margin: EdgeInsets.only(bottom: getH(context, 1)),
            child: TextFormField(
              controller: textController,
              // 入力されたテキストの色
              style: TextStyle(
                color: isDarkMode ? Colors.white : textIconColor
              ),
              decoration: InputDecoration(
                fillColor: isDarkMode ? Colors.black : Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                // 枠線の色
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.black : textIconColor,
                    width: 1,
                  ),
                ),
                // 入力中の枠線の色
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.black : textIconColor,
                    width: 1,
                  ),
                ),
                hintText: '10文字以内',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : textIconColor,
                ),
              ),
            ),
          ),
          const TitleContainer(titleStr: '居住地'),
          // 居住地選択欄
          UserSelectItemContainer(
            text: addressList[selectedAddressIndex],
            onPressed: () => showDialog(
              ItemCupertinoPicker(
                itemAry: addressList,
                provider: addressProvider,
              ),
            ),
          ),
          const TitleContainer(titleStr: '生年月日'),
          // 生年月日選択欄
          UserSelectItemContainer(
            text: selectedBirthday,
            onPressed: () {
              DatePicker.showDatePicker(context,
                theme: isDarkMode ? DatePickerTheme(
                  backgroundColor: Colors.black,
                  itemStyle: const TextStyle(color: Colors.white, fontSize: 18),
                  containerHeight: MediaQuery.of(context).size.height / 4,
                ) : null,
                showTitleActions: false,
                minTime: DateTime(1950, 1, 1),
                maxTime: DateTime(2020, 12, 31),
                onChanged: (date) {
                  final notifier = ref.read(birthdayProvider.notifier);
                  notifier.state = '${date.year}/${date.month}/${date.day}';
                },
                currentTime: selectedBirthday == noSelectOptionMessage
                  ? DateTime(2000, 6, 15)
                  : convertStringToDateTime(selectedBirthday),
                locale: LocaleType.jp
              );
            }
          ),
          SizedBox(height: getH(context, 3)),
          GreenButton(
            text: '登録',
            fontSize: 18,
            // ニックネームと生年月日が入力されていない場合、ボタンを押せなくする
            onPressed: loadingState || textController.text == "" || selectedBirthday == noSelectOptionMessage
              ? null
              : () async {
                ref.watch(loadingIndicatorProvider.notifier).state = true;  // onPressedの処理が全て終わるまでローディング中の状態にする
                // ニックネームが10文字より長い場合、ダイアログで警告
                if (textController.text.length > 10) {
                  ref.watch(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                  await textMessageDialog(context, textOverErrorMessage);
                  return;
                }
                final userUid = ref.watch(authViewModelProvider.notifier).getUid();
                final birthday = convertStringToDateTime(selectedBirthday);
                final now = DateTime.now();
                final userInfoModel = UserInfoModel(
                  firebaseAuthUid: userUid,
                  name: textController.text,
                  addressIndex: selectedAddressIndex,
                  birthday: birthday,
                  createdAt: now,
                  updatedAt: now,
                );

                // ユーザーの登録処理
                await ref.watch(userEditProvider).register(userInfoModel);
                // 最後まで登録処理ができた場合（loadingやerrorではないとき）
                if (ref.read(userEditStateProvider).value == null) {
                  ref.watch(loadingIndicatorProvider.notifier).state = false;  // ローディング終了の状態にする
                  if (context.mounted) context.go('/bottom_bar');
                }
              }
          ),
        ],
      ),
    );

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: titleBox("ユーザー登録", context),
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

