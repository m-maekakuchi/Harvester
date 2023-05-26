import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';

import '../../../handlers/padding_handler.dart';
import '../../widgets/ImagePickerAndCrop.dart';

final cardProvider = StateProvider((ref) => 0);
final dateProvider = StateProvider((ref) => DateTime.now());
// trueならお気に入り登録する
final bookmarkProvider = StateProvider((ref) => false);

const double _kItemExtent = 32.0;
const List<String> cardAry = <String>[
  '日本下水道事業団 00-101-A001',
  'UR都市機構 00-102-A001',
  '札幌市（A001） 01-100-A001',
  '札幌市（B001） 01-100-B001',
  '函館市 01-202-A001',
  '小樽市 01-203-A002',
];

class MyCardEditPage extends ConsumerWidget {

  const MyCardEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardIndex = ref.watch(cardProvider);
    final date = ref.watch(dateProvider);
    final bookmark = ref.watch(bookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
              children: [
                Image.asset(
                    width: getW(context, 10),
                    height: getH(context, 10),
                    'images/AppBar_logo.png'
                ),
                const Text("My Card 編集"),
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
      body: Column(
        children: [
          // 下のDoneボタンをbottomに固定するために、それ以外のWidgetをExpandedで囲んでいる
          Expanded(
            child: SingleChildScrollView(
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
                  _titleContainer("カード", context),
                  // 取得カードの選択欄
                  Container(
                    width: getW(context, 90),
                    height: getH(context, 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: textIconColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: getW(context, 5)),
                      onPressed: () => _showDialog(
                        cardPicker(cardIndex, ref),
                        context
                      ),
                      child: _selectedItemAndIconRow(cardAry[cardIndex]),
                    ),
                  ),
                  _titleContainer("収集日", context),
                  // 収集日の選択欄
                  Container(
                    width: getW(context, 90),
                    height: getH(context, 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: textIconColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CupertinoButton( // TextIconでもいいけど日付選択欄のボタンにあわせてデザイン揃えている
                      padding: EdgeInsets.symmetric(horizontal: getW(context, 5)),
                      onPressed: () async {
                        final selectedDate = await showDate(context, date);
                        // 日付が選択された場合
                        if (selectedDate != null) {
                          final notifier = ref.read(dateProvider.notifier);
                          notifier.state = selectedDate;
                        }
                      },
                      child: _selectedItemAndIconRow('${date.year}/${date.month}/${date.day}'),
                    ),
                  ),
                  SizedBox(height: getH(context, 2),),
                  // お気に入り登録設定
                  IconButton(
                    onPressed: () {
                      final notifier = ref.read(bookmarkProvider.notifier);
                      notifier.state = !bookmark;
                    },
                    iconSize: getW(context, 10),
                    icon: Icon(
                      bookmark ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    ),
                    color: textIconColor,
                  ),
                  SizedBox(height: getH(context, 2),),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: getH(context, 10),
            color: Colors.white,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.done_rounded),
              iconSize: 50,
              color: textIconColor,
            ),
          ),
        ],
      ),
    );
  }

  // 取得カードのPickerを表示
  Widget cardPicker(int initIndex, WidgetRef ref) {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: _kItemExtent,
      scrollController: FixedExtentScrollController(
        initialItem: initIndex,
      ),
      // 項目が選択された場合
      onSelectedItemChanged: (int selectedItem) {
        final notifier = ref.read(cardProvider.notifier);
        notifier.state = selectedItem;
      },
      children:
      List<Widget>.generate(cardAry.length, (int index) {
        return Center(child: Text(cardAry[index]));
      }),
    );
  }

  // ドラムロール(カード選択)
  void _showDialog(Widget child, BuildContext context) {
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
  Future<DateTime?> showDate(context, date) {
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

  // 選択項目のタイトル
  Widget _titleContainer(title, context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: getW(context, 5)),
      margin: EdgeInsets.only(top: getH(context, 3), bottom: getH(context, 1)),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: textIconColor,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  // 選択した項目とアイコンのRow
  Widget _selectedItemAndIconRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          style: const TextStyle(
            color: textIconColor,
            fontSize: 16,
          ),
          text,
        ),
        const Icon(
          Icons.arrow_drop_down_rounded,
          size: 40,
          color: textIconColor,
        ),
      ],
    );
  }
}

