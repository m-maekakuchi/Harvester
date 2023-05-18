import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/app_color.dart';
import '../../../handlers/padding_handler.dart';
import '../../../viewModels/AuthController.dart';

void main() async{
  runApp(const TelIdentificationPage());
}

class TelIdentificationPage extends ConsumerStatefulWidget {
  const TelIdentificationPage({super.key});

  @override
  ConsumerState createState() => _TelIdentificationPage();
}

class _TelIdentificationPage extends ConsumerState<TelIdentificationPage> {

  String iphone = '';
  
  @override
  Widget build(BuildContext context) {
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
                const Text("電話番号認証"),
              ]
          ),
        ),
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
      ),
      body: Center(
        child: Column(
          children:[
            SizedBox(
              height: getH(context, 5),
            ),
            Container(
              width: getW(context, 90),
              height: getH(context, 28),
              decoration: BoxDecoration(
                color: Colors.white,
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
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.local_phone_rounded,
                              color: textIconColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: textIconColor,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: textIconColor,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            // iphone= value;
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
                        "※ハイフンなし",
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
            SizedBox(
              width: getW(context, 80),
              height: getH(context, 7),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: textIconColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)
                  )
                ),
                onPressed: () async{
                  final phoneNumber = "+81 " + iphone;
                  await ref.read(authControllerProvider.notifier).verifyPhoneNumberNative(phoneNumber, context);
                },
                child: const Text(
                  '次へ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

