import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(ProviderScope(child: MyApp()),);
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  Provider<GoRouter> routerProvider = router();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
      ],
      // title: 'BATTLE CHECK',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: textIconColor)),
        // primaryColorDark: Colors.black,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: textIconColor,
            size: 30,
          ),
          color: themeColor,
          foregroundColor: textIconColor,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(color: textIconColor, fontSize: 20),
            pickerTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          )
        )
      ),
      // themeMode: ThemeMode.dark,

      // GoRouter設定
      routeInformationProvider: ref.watch(routerProvider).routeInformationProvider,
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
    );
  }
}