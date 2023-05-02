import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../handlers/padding_handler.dart';
import '../../viewModels/auth_view_model.dart';
void main() async{
  runApp(const TopPage());
}

// class TopPage extends StatelessWidget {
class TopPage extends ConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(247, 255, 231, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              Image.asset(
                width: getW(context, 80),
                height: getH(context, 30),
                'images/harvester_logo.png'
              ),
              Image.asset(
                width: getW(context, 70),
                height: getH(context, 25),
                'images/manhole.png'
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
                    // ref.read(authViewModelProvider.notifier).signInWithGoogle();
                    context.go('/cards_list_page');
                  },
                  child: const Text(
                    'Google',
                    style: TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
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
                  onPressed: null,
                  child: const Text(
                    'LINE',
                    style: TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
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
                    context.go('/register/tel_identification_page');
                  },
                  child: const Text(
                    '電話番号',
                    style: TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}