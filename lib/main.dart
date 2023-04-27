import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'views/pages/top_page.dart';
import 'views/pages/tel_identification_page.dart';
import 'views/pages/cards_list_page.dart';

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
  runApp(const ProviderScope(child: MyApp()),);
}

final GoRouter _router = GoRouter(
  // redirect: (BuildContext context, GoRouterState state) {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     return '/cards_list_page';
  //   } else {
  //     return null;
  //   }
  // },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TopPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'tel_identification_page',
          builder: (BuildContext context, GoRouterState state) {
            return const TelIdentificationPage();
          },
        ),
        GoRoute(
          path: 'cards_list_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CardsListPage();
          },
        ),
        // GoRoute(
        //   path: 'cards_info_page',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const CardsInfoPage();
        //   },
        // ),
      ],
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}