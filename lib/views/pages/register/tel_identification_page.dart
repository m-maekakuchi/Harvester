import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/views/widgets/text_message_dialog.dart';

import '../../components/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../commons/message.dart';
import '../../../handlers/padding_handler.dart';
import '../../../provider/providers.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../widgets/green_button.dart';

final phoneNumberControllerProvider = StateProvider.autoDispose((ref) => TextEditingController(text: ''));
final enableProvider = StateProvider.autoDispose((ref) => false);

class TelIdentificationPage extends ConsumerWidget {
  const TelIdentificationPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final appBarColorIndex = ref.watch(colorProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final telNumberIsNotEmpty = ref.watch(enableProvider);

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: titleBox("電話番号認証", context),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       primaryFocus?.unfocus();
          //       context.go('/top_page');
          //     },
          //     icon: const Icon(
          //       Icons.clear_rounded,
          //       size: 40
          //     ),
          //   ),
          // ],
          backgroundColor: themeColorChoice[appBarColorIndex],
        ),
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
                            "携帯電話番号",
                            style: TextStyle(
                              fontSize: 18,
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
                            "入力後に認証コードが送信されます。",
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
                          Expanded(
                            child: TextFormField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                              style: TextStyle( // 入力された文字の色
                                color: isDarkMode ? Colors.white : textIconColor,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.local_phone_rounded,
                                ),
                                prefixIconColor: isDarkMode ? Colors.white : textIconColor,
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
                                final bool = phoneNumberController.text.isNotEmpty ? true : false;
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
                        height: getH(context, 1),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: getW(context, 5),
                          ),
                          const Text(
                            "※ ハイフンなし, 11桁",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getH(context, 3),
                      ),
                    ],
                  )
                ),
                SizedBox(
                  height: getH(context, 5),
                ),
                GreenButton(
                  text: '次へ',
                  fontSize: 18,
                  onPressed: telNumberIsNotEmpty
                    ? () async {
                      /// **************最後に復活させる**************
                      // if (phoneNumberController.text.length != 11) {
                      //   textMessageDialog(context, telNumberLengthErrorMessage);
                      //   return;
                      // }
                      try {
                        final phoneNumber = "+81 ${phoneNumberController.text}";
                        await ref.read(authViewModelProvider.notifier).verifyPhoneNumberNative(phoneNumber, context);
                      } catch(e) {
                        debugPrint(e.toString());
                      }
                    }
                    : null,
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

