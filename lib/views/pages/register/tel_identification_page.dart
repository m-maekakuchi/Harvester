import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '電話番号認証'
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
                              prefixIcon: Icon(Icons.local_phone_rounded),
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
                    backgroundColor: const Color.fromRGBO(203, 255, 211, 1),
                    foregroundColor: const Color.fromRGBO(112, 112, 112, 1),
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
      ),
    );
  }
}

