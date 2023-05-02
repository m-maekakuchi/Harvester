import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/viewModels/AuthController.dart';
import 'package:harvester/views/pages/cards/card_detail_page.dart';
import 'package:harvester/views/pages/cards/card_edit_page.dart';
import 'package:harvester/views/pages/cards/cards_list_page.dart';
import 'package:harvester/views/pages/collections/collection_add_page.dart';
import 'package:harvester/views/pages/collections/collection_page.dart';
import 'package:harvester/views/pages/home_page.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';
import 'package:harvester/views/pages/settings/setting_page.dart';
import 'package:harvester/views/pages/settings/setting_profile_page.dart';
import 'package:harvester/views/pages/register/tel_identification_page.dart';
import 'package:harvester/views/pages/welcome_page.dart';
import 'package:harvester/views/pages/register/user_info_page.dart';
import 'commons/RedirectPath.dart';


Provider<GoRouter> router() {
  return Provider((ref) =>
    GoRouter(
      redirect: (context, state) async {
        // return '/register/tel_identification_page';
        // authControllerProviderに変更があった場合に動くイメージ
        final auth = ref.watch(authControllerProvider);
        bool isSignedIn = auth.value != null;

        // サインアウトするときのコード
        // ref.watch(authControllerProvider.notifier).signOut();

        // AuthControllerメソッド呼ぶときnotifierつける
        final user = ref.watch(authControllerProvider.notifier).getCurrentUser();
        String requestPagePath = state.subloc;

        // アクセスしようとしているパスがnotLoginSignInPathに入ってるか
        final goingToSignIn = RedirectPath.notLoginSignInPath.contains(requestPagePath);
        // print(goingToSignIn);
        // サインインしてない && notLoginSignInPath以外に入ろうとしてる
        if (!isSignedIn && !goingToSignIn) {
          return '/';
        } else if (isSignedIn) {
          // サインインしてるのに、トップとか電話番号認証に入ろうとしてる
          if (requestPagePath == '/' || goingToSignIn) {
            final result = await user!.getIdTokenResult(true);

            await ref.watch(authControllerProvider.notifier).reload();
            return '/home_page';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const TopPage();
          },
        ),
        GoRoute(
          path: '/register/tel_identification_page',
          builder: (BuildContext context, GoRouterState state) {
            print(67);
            return const TelIdentificationPage();
          },
        ),
        GoRoute(
          path: '/register/user_info_page',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfoPage();
          },
        ),
        GoRoute(
          path: '/home_page',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/collections/collection_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CollectionPage();
          },
        ),
        GoRoute(
          path: '/collections/collection_add_page',
          builder: (BuildContext context, GoRouterState state) {
            return const ColletionAddPage();
          },
        ),
        GoRoute(
          path: '/cards/cards_list_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CardsListPage();
          },
        ),
        GoRoute(
          path: '/cards/card_detail_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CardDetailPage();
          },
        ),
        GoRoute(
          path: '/cards/card_edit_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CardEditPage();
          },
        ),
        GoRoute(
          path: '/settings/setting_page',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingPage();
          },
        ),
        GoRoute(
          path: '/settings/setting_profile_page',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingProfilePage();
          },
        ),
        GoRoute(
          path: '/photos/photos_list_page',
          builder: (BuildContext context, GoRouterState state) {
            return const PhotosListPage();
          },
        ),
      ],
    )
  );
}