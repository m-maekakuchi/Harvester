import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/router.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'commons/app_color.dart';
import 'repositories/local_storage_repository.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //  App Checkの初期化
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.appAttest,
  // );
  // Hiveの初期化
  await LocalStorageRepository().init();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(ProviderScope(
    // device_previewのセットアップ
    // child: DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(),
    // )),
    child: MyApp())
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  Provider<GoRouter> routerProvider = router();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  // 縦向きのみ許可

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,  // 画面右上の「DEBUG」表示を消す
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      useInheritedMediaQuery: true,           // device_previewを使用するのに必要
      locale: DevicePreview.locale(context),  // device_previewを使用するのに必要
      builder: DevicePreview.appBuilder,      // device_previewを使用するのに必要
      supportedLocales: const [
        Locale('ja'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: textIconColor)),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: textIconColor,
            size: 30,
          ),
          foregroundColor: textIconColor,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(color: textIconColor, fontSize: 20),
            pickerTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          )
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: textIconColor,
            size: 30,
          ),
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