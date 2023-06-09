import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/address_master_list.dart';
import '../../../commons/app_color.dart';
import '../../../commons/message.dart';
import '../../components/message_dialog.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/user_info_model.dart';
import '../../../repositories/local_storage_repository.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/user_view_model.dart';
import '../../components/title_container.dart';
import '../../widgets/green_button.dart';
import '../../components/user_select_item_container.dart';
import '../../widgets/item_cupertino_picker.dart';

final textControllerProvider = StateProvider((ref) => TextEditingController());
final addressProvider = StateProvider((ref) => 12);
final birthdayProvider = StateProvider((ref) => noSelectOptionMessage);

class UserInfoRegisterPage extends ConsumerWidget {
  const UserInfoRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textController = ref.watch(textControllerProvider);
    final selectedAddressIndex = ref.watch(addressProvider);
    final selectedBirthday = ref.watch(birthdayProvider);

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

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
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
                const Text("ユーザー登録", style: TextStyle(fontSize: 18)),
              ]
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const TitleContainer(titleStr: 'ニックネーム'),
              //  ニックネーム欄
              SizedBox(
                width: getW(context, 90),
                height: getH(context, 6),
                child: TextFormField(
                  /// validator: ,
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
                text: '登録',
                fontSize: 18,
                // ニックネームと生年月日が入力されていない場合、ボタンを押せなくする
                onPressed: textController.text == "" || selectedBirthday == noSelectOptionMessage
                  ? null
                  : () async {
                    // ニックネームが10文字より長い場合、ダイアログで警告
                    if (textController.text.length > 10) {
                      await messageDialog(context, textOverErrorMessage);
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

                    // userViewModelProviderの状態を変更してFireStoreに登録する
                    ref.watch(userViewModelProvider.notifier).setState(userInfoModel);
                    ref.watch(userViewModelProvider.notifier).setToFireStore();

                    // Hiveでローカルにユーザー情報を保存
                    await LocalStorageRepository().putUserInfo(userInfoModel);

                    // ユーザ情報の登録が完了したことをCustom Claimに登録
                    await ref.read(authViewModelProvider.notifier).registerCustomStatus();

                    if (context.mounted) context.go('/bottom_bar');
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

