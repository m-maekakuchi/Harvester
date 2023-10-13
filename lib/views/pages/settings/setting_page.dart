import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/repositories/local_storage_repository.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/message.dart';
import '../../../handlers/padding_handler.dart';
import '../../../provider/providers.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/user_view_model.dart';
import '../../widgets/message_dialog_two_actions.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final appBarColorIndex = ref.watch(colorProvider);

    // 設定グループのタイトルのWidget
    Widget groupTitleComponent(String text) {
      return Container(
        width: double.infinity,
        height: getH(context, 7),
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: getW(context, 3), bottom: getW(context, 1)),
        child: Text(text, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white : textIconColor)),
      );
    }

    // 各設定項目の間の境界線
    final itemBorder = Container(
      color: isDarkMode ? Colors.white : textIconColor,
      width: getW(context, 96),
      height: 0.5,
    );

    // 各設定項目のWidget
    Widget itemComponent(String text, GestureTapCallback onPressed) {
      return SizedBox(
        width: double.infinity,
        height: getH(context, 7),
        child: TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: getW(context, 3), right: getW(context, 4)),
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            foregroundColor: isDarkMode ? Colors.white : textIconColor,
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
    Widget colorBall(int index) {
      return Container(
        width: getH(context, 5),
        height: getH(context, 5),
        margin: EdgeInsets.all(getW(context, 3)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColorChoice[index],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45)
            )
          ),
          // 色が選択された場合
          onPressed: () async {
            final notifier = ref.read(colorProvider.notifier);
            notifier.state = index;

            // 選択された色をCustom Claimに登録
            await ref.read(authViewModelProvider.notifier).registerColorIndex(index);
          },
          child: const SizedBox.shrink(),
        ),
      );
    }
    
    // テーマカラー選択のダイアログ
    Future<void> dialogBuilder() {
      final length = themeColorChoice.length / 4;

      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Consumer(builder: (context, ref, _) {
            return AlertDialog(
              title: Center(
                child: Text(
                  selectColorMessage,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : textIconColor,
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
                          for (int j = i * 3; j < i * 3 + 3; j++) ... {
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                colorBall(j),
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
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 30,
                        color: isDarkMode ? Colors.white : textIconColor,
                      ),
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
        title: titleBox("設定", context),
        backgroundColor: themeColorChoice[appBarColorIndex],
      ),
      body: Column(
        children: [
          groupTitleComponent("アカウント"),
          itemComponent(
            '編集',
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
          ),
          itemBorder,
          itemComponent(
            'ログアウト',
            () async {
              messageDialogTwoActions(
                context,
                logOutMessage,
                null,
                dialogPopText,
                dialogLogOutPushText,
                () async {
                  ref.read(colorProvider.notifier).state = 4;           // テーマカラーの初期化
                  ref.read(bottomBarIndexProvider.notifier).state = 0;  // bottomBarのインデックスの初期化
                  // サインアウト
                  await ref.read(authViewModelProvider.notifier).signOut();
                }
              );
            }
          ),
          groupTitleComponent("アプリの設定"),
          itemComponent(
            'テーマカラー',
            () {
              dialogBuilder();
            }
          ),
          groupTitleComponent("アプリについて"),
          itemComponent(
            '利用規約',
            () { }
          ),
          itemBorder,
          itemComponent(
            'プライバシーポリシー',
            () { }
          ),
        ],
      ),
    );
  }

}