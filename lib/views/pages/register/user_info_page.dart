import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

import '../../../commons/app_color.dart';
import '../../widgets/GreenButton.dart';

const double _kItemExtent = 32.0;
const List<String> _addressAry = <String>[
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

void main() async{
  runApp(const UserInfoPage());
}

final addressProvider = StateProvider((ref) => 12);
final birthdayProvider = StateProvider((ref) => '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}');

class UserInfoPage extends ConsumerWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAddress = ref.watch(addressProvider);
    final selectedBirthday = ref.watch(birthdayProvider);
    final spaceHeight1 = SizedBox(
      height: getH(context, 1),
    );
    final spaceHeight3 = SizedBox(
      height: getH(context, 3),
    );
    final spaceHeight5 = SizedBox(
      height: getH(context, 5),
    );
    final spaceWidth5 = SizedBox(
      width: getW(context, 5),
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

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                width: getW(context, 8),
                height: getH(context, 8),
                'images/AppBar_logo.png'
              ),
              const Text("ユーザー登録"),
            ]
          ),
        ),
      ),
      // 日本語キーボード表示時のOVERFLOWに対する対応
      body: SingleChildScrollView(
        child: Column(
          children: [
            spaceHeight5,
            Row(
              children: [
                spaceWidth5,
                const SizedBox(
                  child: Text(
                    'ニックネーム',
                    style: TextStyle(
                      fontSize: 18,
                      color: textIconColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            spaceHeight1,
            // ニックネーム欄
            SizedBox(
              width: getW(context, 90),
              height: getH(context, 6),
              child: TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return '入力してください';
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: '10文字以内',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: textIconColor,
                  ),
                ),
              ),
            ),
            spaceHeight3,
            Row(
              children: [
                spaceWidth5,
                const SizedBox(
                  child: Text(
                    '居住地',
                    style: TextStyle(
                      fontSize: 18,
                      color: textIconColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            spaceHeight1,
            // 居住地選択欄
            Container(
              width: getW(context, 90),
              height: getH(context, 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: textIconColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getW(context, 89),
                    child: CupertinoButton(
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.white,
                      onPressed: () =>
                        showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: _kItemExtent,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedAddress,
                            ),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              final notifier = ref.read(addressProvider.notifier);
                              notifier.state = selectedItem;
                            },
                            children:
                            List<Widget>.generate(
                              _addressAry.length, (int index) {
                                return Text(
                                  _addressAry[index],
                                  style: const TextStyle(
                                    color: textIconColor,
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      // alignment: Alignment.space,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _addressAry[selectedAddress],
                            style: const TextStyle(
                              color: textIconColor,
                              fontSize: 16
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 40,
                            color: textIconColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Icon(
                  //   Icons.arrow_drop_down_rounded,
                  //   size: 40,
                  //   color: textIconColor,
                  // ),
                ],
              ),
            ),
            spaceHeight3,
            Row(
              children: [
                spaceWidth5,
                const SizedBox(
                  child: Text(
                    '生年月日',
                    style: TextStyle(
                      fontSize: 18,
                      color: textIconColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            spaceHeight1,
            // 生年月日選択入力欄
            Container(
              width: getW(context, 90),
              height: getH(context, 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: textIconColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton (
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 20),
                ),
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
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: textIconColor,
                        fontSize: 16,
                      ),
                      selectedBirthday,
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 40,
                      color: textIconColor,
                    ),
                  ],
                ),
              ),
            ),
            spaceHeight5,
            GreenButton(
              text: '登録',
              fontSize: 18,
              onPressed: () {
                context.go('/home_page');
              },
            ),
          ]
        ),
      )
    );
  }
}

