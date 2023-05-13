import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/handlers/padding_handler.dart';

const double _kItemExtent = 32.0;
const List<String> _fruitNames = <String>[
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

class UserInfoPage extends ConsumerWidget {
  const UserInfoPage({super.key});

//   @override
//   State<UserInfoPage> createState() => _UserInfoPageState();
// }
//
// class _UserInfoPageState extends State<UserInfoPage> {
//   int _selectedFruit = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAddress = ref.watch(addressProvider);

    // 居住地のドラムロール
    void showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
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
        )
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text('プロフィール登録')),
        body: Column(
            children: [
              SizedBox(
                height: getH(context, 5),
              ),
              Row(
                children: [
                  SizedBox(
                    width: getW(context, 5),
                  ),
                  const SizedBox(
                    child: Text(
                      'ニックネーム',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getH(context, 1),
              ),
              // ニックネーム欄
              SizedBox(
                width: getW(context, 90),
                height: getH(context, 6),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  },
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
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getH(context, 3),
              ),
              Row(
                children: [
                  SizedBox(
                    width: getW(context, 5),
                  ),
                  const SizedBox(
                    child: Text(
                      '居住地',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getH(context, 1),
              ),
              // 居住地欄
              Container(
                width: getW(context, 90),
                height: getH(context, 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color.fromRGBO(95, 99, 104, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                              _fruitNames.length, (int index) {
                            return Text(
                              _fruitNames[index],
                            );
                          }),
                        ),
                      ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _fruitNames[selectedAddress],
                    style: const TextStyle(
                      color: Color.fromRGBO(95, 99, 104, 1),
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getH(context, 3),
              ),
              Row(
                children: [
                  SizedBox(
                    width: getW(context, 5),
                  ),
                  const SizedBox(
                    child: Text(
                      '生年月日',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getH(context, 5),
              ),
              SizedBox(
                width: getW(context, 80),
                height: getH(context, 7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(205, 235, 195, 1),
                      foregroundColor: const Color.fromRGBO(95, 99, 104, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)
                      )
                  ),
                  onPressed: () {
                    context.go('/home_page');
                  },
                  child: const Text(
                    '登録',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ]
        )
    );
  }
}

