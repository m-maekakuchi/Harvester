import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/views/widgets/GreenButton.dart';

import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../components/ItemTitle.dart';
import '../../widgets/ItemCupertinoPicker.dart';
import '../../widgets/ItemFieldUserSelect.dart';

const List<String> addressAry = [
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];

/// 初期値はユーザーの登録情報から取ってくる
// TextEditingControllerのtextでTextFormFieldの初期値を設定
final textControllerProvider = StateProvider((ref) => TextEditingController(text: '初期値'));
final addressProvider = StateProvider((ref) => 12);
final birthdayProvider = StateProvider((ref) => '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}');

class ProfileEditePage extends ConsumerWidget {
  const ProfileEditePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textController = ref.watch(textControllerProvider);
    final selectedAddress = ref.watch(addressProvider);
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
              const ItemTitle(titleStr: 'ニックネーム'),
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
              const ItemTitle(titleStr: '居住地'),
              // 居住地選択欄
              ItemFieldUserSelect(
                text: addressAry[selectedAddress],
                onPressed: () => showDialog(
                  ItemCupertinoPicker(
                    itemAry: addressAry,
                    provider: addressProvider,
                  ),
                ),
              ),
              const ItemTitle(titleStr: '生年月日'),
              // 生年月日選択欄
              ItemFieldUserSelect(
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
                onPressed: () {
                  context.pop();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

}