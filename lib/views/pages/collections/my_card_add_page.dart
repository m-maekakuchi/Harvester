import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/views/components/ItemTitle.dart';
import 'package:harvester/views/widgets/GreenButton.dart';

import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../widgets/BookMarkButton.dart';
import '../../widgets/ImagePickerAndCrop.dart';
import '../../widgets/ItemCupertinoPicker.dart';
import '../../widgets/ItemFieldUserSelect.dart';

final cardProvider = StateProvider((ref) => 0);
final dateProvider = StateProvider((ref) => DateTime.now());
// trueならお気に入り登録する
final bookmarkProvider = StateProvider((ref) => false);

const List<String> cardAry = <String>[
  '日本下水道事業団 00-101-A001',
  'UR都市機構 00-102-A001',
  '札幌市（A001） 01-100-A001',
  '札幌市（B001） 01-100-B001',
  '函館市 01-202-A001',
  '小樽市 01-203-A002',
];

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final cardIndex = ref.watch(cardProvider);
    final date = ref.watch(dateProvider);

    // ドラムロール(カード選択)
    void showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height / 3,
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

    // 日付のPickerを表示
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
                primary: themeColor, // ヘッダー背景色
                onPrimary: textIconColor, // ヘッダーテキストカラー
                onSurface: textIconColor, // カレンダーのテキストカラー
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
        child: Column(
          children: [
            SizedBox(height: getH(context, 3),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ImagePickAndCrop(),
                ImagePickAndCrop(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ImagePickAndCrop(),
                ImagePickAndCrop(),
              ],
            ),
            const ItemTitle(titleStr: 'カード'),
            // カード選択欄
            ItemFieldUserSelect(
              text: cardAry[cardIndex],
              onPressed: () => showDialog(
                ItemCupertinoPicker(
                  provider: cardProvider,
                  itemAry: cardAry
                ),
              ),
            ),
            const ItemTitle(titleStr: '収集日'),
            // 収集日選択欄
            ItemFieldUserSelect(
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
            BookMarkButton(provider: bookmarkProvider),
            SizedBox(height: getH(context, 2),),
            GreenButton(
              text: '登録',
              fontSize: 18,
              onPressed: () {},
            ),
          ]
        ),
      ),
    );
  }

}