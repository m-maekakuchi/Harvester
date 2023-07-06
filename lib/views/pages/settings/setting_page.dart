import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/repositories/local_storage_repository.dart';

import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/user_view_model.dart';
import '../../widgets/setting_accordion.dart';

final colorProvider = StateProvider((ref) => 5);

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectColorIndex = ref.watch(colorProvider);

    // Accordion以外の項目はTextButton
    Widget itemTextItem(String text, GestureTapCallback onPressed) {
      return SizedBox(
        width: double.infinity,
        height: getH(context, 7.4),
        child: TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: getW(context, 3), right: getW(context, 4)),
            side: const BorderSide(
                color: textIconColor,
                width: 0.2
            ),
            backgroundColor: Colors.white,
            foregroundColor: textIconColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: const TextStyle(fontSize: 16)),
              const Icon(Icons.arrow_forward_ios, size: 15),
            ],
          ),
        )
      );
    }

    // 選択できる色の丸
    Widget colorBall(Color color, int index, WidgetRef ref) {
      return Container(
        width: getW(context, 10),
        height: getW(context, 10),
        margin: EdgeInsets.all(getW(context, 3)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
            )
          ),
          // 色が選択された場合
          onPressed: () {
            final notifier = ref.read(colorProvider.notifier);
            notifier.state = index;
          },
          child: const SizedBox.shrink(),
        ),
      );
    }
    
    // テーマカラー選択のダイアログ
    Future<void> dialogBuilder(int selectColorIndex, WidgetRef ref) {
      final length = themeColorChoice.length / 4;

      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Consumer(builder: (context, ref, _) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    '色を選択してください',
                    style: TextStyle(
                      color: textIconColor,
                      fontSize: 18,
                    ),
                  )
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < length; i++) ... {
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int j = i * 4; j < i * 4 + 4; j++) ... {
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  colorBall(themeColorChoice[j], j, ref),
                                  // 選択されたらチェックアイコンを上に表示
                                  if (ref.watch(colorProvider) == j) ... {
                                    const Icon(Icons.done_rounded, color: textIconColor),
                                  }
                                ]
                              ),
                            }
                          ],
                        ),
                      },
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 30, color: textIconColor,),
                        /// themeColorを選択された色に変える処理をあとでここに書く
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
          }
      );
    }

    return Scaffold(
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
              const Text("設定"),
            ]
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: getH(context, 3),),
          SettingAccordion(
            title: 'アカウント',
            listItemAry: [
              [
                'プロフィール編集',
                () async {
                  // ローカルに保存されたユーザー情報を取得
                  var userInfoModel = await LocalStorageRepository().fetchUserInfo();
                  // ローカルにユーザー情報が保存されていない場合、Firebaseから取得
                  if (userInfoModel == null) {
                    final uid = ref.watch(authViewModelProvider.notifier).getUid();
                    await ref.read(userViewModelProvider.notifier).getOnlyInfoFromFireStore(uid);
                  } else {
                    // ローカルにユーザー情報があった場合は、UserViewModelにセット
                    await ref.read(userViewModelProvider.notifier).setState(userInfoModel);
                  }
                  if (context.mounted) context.push("/settings/user_info_edit_page");
                },
              ],
              [
                'ログアウト',
                () {},
              ],
              [
                '退会する',
                () {},
              ]
            ],
          ),
          itemTextItem(
            'テーマカラー',
            () {
              dialogBuilder(selectColorIndex, ref);
            }
          ),
          itemTextItem(
            '利用規約',
            () { }
          ),
          itemTextItem(
            'プライバシーポリシー',
            () { }
          ),
        ],
      ),
    );
  }

}