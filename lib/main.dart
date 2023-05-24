import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/router.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'commons/app_color.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化
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
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: textIconColor)),
        // primaryColorDark: Colors.black,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: textIconColor,
            size: 30,
          ),
          color: themeColor,
          foregroundColor: textIconColor,
        ),
      ),
      // themeMode: ThemeMode.dark,

      // GoRouter設定
      routeInformationProvider: ref.watch(routerProvider).routeInformationProvider,
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
    );
  }
}