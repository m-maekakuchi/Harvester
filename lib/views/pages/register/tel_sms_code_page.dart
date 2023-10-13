import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../../provider/providers.dart';
import '../../widgets/green_button.dart';
import '../../widgets/modal_barrier.dart';

final smsCodeControllerProvider = StateProvider.autoDispose((ref) => TextEditingController(text: ''));
final enableProvider = StateProvider.autoDispose((ref) => false);

class TelSmsCodePage extends ConsumerWidget {
  const TelSmsCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final phoneVerificationState = ref.watch(phoneVerificationStateProvider); // 認証処理の状況を監視

    final appBarColorIndex = ref.watch(colorProvider);
    final smsCodeController = ref.watch(smsCodeControllerProvider);
    final smsCodeIsNotEmpty = ref.watch(enableProvider);

    final bodyWidget = GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children:[
                SizedBox(
                  height: getH(context, 5),
                ),
                Container(
                  width: getW(context, 90),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getH(context, 3),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          const Text(
                            "認証コード",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 1),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          const Text(
                            "認証コードを入力してください。",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 1),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          Expanded (
                            child: TextFormField(
                              controller: smsCodeController,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : textIconColor,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDarkMode ? Colors.white : textIconColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeColorChoice[appBarColorIndex],
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                final bool = smsCodeController.text.isNotEmpty ? true : false;
                                ref.read(enableProvider.notifier).state = bool;
                              },
                            ),
                          ),
                          SizedBox(
                            width: getW(context, 5),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 4),
                      ),
                    ]
                  ),
                ),
                SizedBox(
                  height: getH(context, 5),
                ),
                GreenButton(
                  text: '完了',
                  fontSize: 18,
                  onPressed: smsCodeIsNotEmpty
                    ? () async {
                      await ref.watch(phoneVerificationProvider).verification(context, smsCodeController);
                    }
                    : null,
                ),
              ]
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: titleBox("端末認証", context),
        backgroundColor: themeColorChoice[appBarColorIndex],
      ),
      body: phoneVerificationState.when(
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
    );
  }
}