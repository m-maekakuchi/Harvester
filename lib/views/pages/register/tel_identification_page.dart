import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/app_bar_contents.dart';
import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../../provider/providers.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../widgets/green_button.dart';

class TelIdentificationPage extends ConsumerStatefulWidget {
  const TelIdentificationPage({super.key});

  @override
  ConsumerState createState() => _TelIdentificationPage();
}

class _TelIdentificationPage extends ConsumerState<TelIdentificationPage> {

  String iphone = '';
  
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final appBarColorIndex = ref.watch(colorProvider);

    return GestureDetector( // キーボードの外側をタップしたらキーボードを閉じる設定
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: titleBox("電話番号認証", context),
          actions: [
            IconButton(
              onPressed: () {
                context.go('/top_page');
              },
              icon: const Icon(
                Icons.clear_rounded,
                size: 40
              ),
            ),
          ],
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
                              keyboardType: TextInputType.phone,
                              style: TextStyle( // 入力された文字の色
                                color: isDarkMode ? Colors.white : textIconColor,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.local_phone_rounded,
                                ),
                                prefixIconColor:isDarkMode ? Colors.white : textIconColor,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDarkMode ? Colors.white : textIconColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDarkMode ? Colors.white : textIconColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                iphone = value;
                              }
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
                            "※ ハイフンなし",
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
                  onPressed: () async{
                    final phoneNumber = "+81 $iphone";
                    await ref.read(authViewModelProvider.notifier).verifyPhoneNumberNative(phoneNumber, context);
                  },
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

