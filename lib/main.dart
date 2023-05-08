import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/router.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'viewModels/auth_view_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化å
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // App Checkの初期化
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(ProviderScope(child: MyApp()),);
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  Provider<GoRouter> routerProvider = router();

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return MaterialApp.router(
      // localizationsDelegates: [
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('ja'),
      // ],
      // title: 'BATTLE CHECK',
      darkTheme: ThemeData(
        // primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color.fromRGBO(248, 251, 242, 1),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Color.fromRGBO(95, 99, 104, 1))),
        // primaryColorDark: Colors.black,
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            color: Color.fromRGBO(205, 235, 195, 1),
            foregroundColor: Color.fromRGBO(95, 99, 104, 1)
        ),
      ),
      themeMode: ThemeMode.dark,

      // GoRouter設定
      routeInformationProvider: ref.watch(routerProvider).routeInformationProvider,
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
    );
  }
}