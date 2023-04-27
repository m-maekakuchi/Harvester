import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../handlers/padding_handler.dart';
import '../../viewModels/auth_view_model.dart';

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
  String verificationId = '';
  String smsCode = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    String phone = "+81$iphone";

    debugPrint("phone:$phone");

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("verificationCompleted");
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("verificationFailed");
        if (e.code == 'invalid-phone-number') {
          debugPrint('電話番号が正しくありません。');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint("codeSent");
        this.verificationId = verificationId;
        
        smsCodeDialog(context).then((value) {
          debugPrint('value$value');
          debugPrint('sign in');
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(247, 255, 231, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(203, 255, 211, 1),
          foregroundColor: const Color.fromRGBO(112, 112, 112, 1),
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
                              iphone= value;
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
                height: getH(context, 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(203, 255, 211, 1),
                    foregroundColor: const Color.fromRGBO(112, 112, 112, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)
                    )
                  ),
                  onPressed: () {
                    verifyPhoneNumber(context);
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


  Future smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext content) {
        return AlertDialog(
          title: const Text(
            '認証コードを入力してください',
            style: TextStyle(
              color: Color.fromRGBO(112, 112, 112, 1),
              fontSize: 16,
            ),
          ),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (String value){
              smsCode = value;
            },
          ),
          contentPadding: const EdgeInsets.all(20),
          actions: <Widget>[
            SizedBox(
              width: getW(context, 30),
              height: getH(context, 8),
              child: ElevatedButton(
                onPressed: () {
                  try {
                    ref.read(authViewModelProvider.notifier).signInWithTel(verificationId, smsCode);
                    context.go('/cards_list_page');
                  } catch(e){
                    debugPrint(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(203, 255, 211, 1),
                  foregroundColor: const Color.fromRGBO(112, 112, 112, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)
                  )
                ),
                child: const Text(
                  "完了",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ),
            ),
          ],
        );
      }
    );
  }

  // signIn() async{
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
  //   await auth.signInWithCredential(credential).then((user) {
  //     context.go('/cards_list_page');
  //   });
  // }
}

