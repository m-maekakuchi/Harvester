import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/viewModels/user_view_model.dart';

import '../../../commons/address_master_list.dart';
import '../../../commons/app_color.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/user_info_model.dart';
import '../../../viewModels/auth_view_model.dart';
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
  dateTimeToString(ref.read(userViewModelProvider).birthday!)
);

class UserInfoEditPage extends ConsumerWidget {
  const UserInfoEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textController = ref.watch(textControllerProvider);
    final selectedAddressIndex = ref.watch(addressIndexProvider);
    final selectedBirthday = ref.watch(birthdayProvider);

    // TextFormFieldのカーソルを末尾に設定
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

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
                const Text("プロフィール編集", style: TextStyle(fontSize: 18)),
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
                text: '登録',
                fontSize: 18,
                // ニックネームが入力されていない場合、ボタンを押せなくする
                onPressed: textController.text == ""
                  ? null
                  : () {
                  final userUid = ref.watch(authViewModelProvider.notifier).getUid();
                  final birthday = convertStringToDateTime(selectedBirthday);
                  final now = DateTime.now();
                  final userInfoModel = UserInfoModel(
                    firebaseAuthUid: userUid,
                    name: textController.text,
                    addressIndex: selectedAddressIndex,
                    birthday: birthday,
                    updatedAt: now,
                  );

                  // userViewModelProviderの状態を変更してFireStoreを更新する
                  ref.watch(userViewModelProvider.notifier).setState(userInfoModel);
                  ref.read(userViewModelProvider.notifier).updateOfFireStore();

                  // context.pop();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

}