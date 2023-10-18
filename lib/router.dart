import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/provider/providers.dart';
import 'package:harvester/viewModels/auth_view_model.dart';
import 'package:harvester/views/pages/bottom_bar.dart';
import 'package:harvester/views/pages/register/tel_sms_code_page.dart';
import 'package:harvester/views/pages/test_page.dart';
import 'package:harvester/views/pages/welcome_page.dart';
import 'package:harvester/views/pages/cards/all_cards_list_page.dart';
import 'package:harvester/views/pages/collections/my_cards_list_page.dart';
import 'package:harvester/views/pages/collections/my_card_add_page.dart';
import 'package:harvester/views/pages/home_page.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';
import 'package:harvester/views/pages/settings/setting_page.dart';
import 'package:harvester/views/pages/settings/user_info_edit_page.dart';
import 'package:harvester/views/pages/register/tel_identification_page.dart';
import 'package:harvester/views/pages/register/user_info_register_page.dart';
import 'commons/redirect_path.dart';
import 'views/pages/error_page.dart';


Provider<GoRouter> router() {
  return Provider((ref) =>
    GoRouter(
      redirect: (context, state) async {
        // return '/error_page';

        // authControllerProviderに変更があった場合に動くイメージ
        final auth = ref.watch(authViewModelProvider);
        bool isSignedIn = auth.value != null;

        // AuthControllerメソッド呼ぶときnotifierつける
        final user = ref.watch(authViewModelProvider.notifier).getCurrentUser();
        String requestPagePath = state.subloc;
        debugPrint("リダイレクトパス：$requestPagePath");
        // アクセスしようとしているパスがnotLoginSignInPathに入ってるか
        final goingToSignIn = RedirectPath.notLoginSignInPath.contains(requestPagePath);
        // サインインしてない && notLoginSignInPath以外に入ろうとしてる
        if (!isSignedIn && !goingToSignIn) {
          debugPrint('----サインインしていない && notLoginSignInPathに入ろうとしている----');
          return '/';
        } else if (isSignedIn) {
          debugPrint('----サインインしている----');
          // サインインしてるのに、トップとか電話番号認証に入ろうとしてる
          if (requestPagePath == '/' || goingToSignIn) {
            debugPrint('----入ってはいけないページにアクセスしようとしている。----');
            final result = await user!.getIdTokenResult(true);
            // debugPrint("*****************************************************");
            // debugPrint(result);
            // debugPrint("*****************************************************");
            await ref.watch(authViewModelProvider.notifier).reload();
            final registerCustomState = result.claims!['registerStatus'];
            debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
            debugPrint("ユーザー情報の登録が完了済か: $registerCustomState");
            debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
            final themeColorIndex = result.claims!['colorIndex'];
            debugPrint("選択中のテーマカラー$themeColorIndex");
            debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
            if (themeColorIndex != null) {
              ref.read(colorProvider.notifier).state = themeColorIndex;
            }
            if (registerCustomState == 1) {
              return '/bottom_bar';
            } else {
              return '/register/user_info_register_page';
            }
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
            return const WelcomePage();
          },
        ),
        /// ＊＊＊＊＊＊＊最後に消す＊＊＊＊＊＊＊
        GoRoute(
          path: '/test_page',
          builder: (BuildContext context, GoRouterState state) {
            return const TestPage();
          },
        ),
        /// ＊＊＊＊＊＊＊最後に消す＊＊＊＊＊＊＊
        GoRoute(
          path: '/error_page',
          builder: (BuildContext context, GoRouterState state) {
            return ErrorPage(state.extra as String?);
          },
        ),
        GoRoute(
          path: '/register/tel_identification_page',
          builder: (BuildContext context, GoRouterState state) {
            return const TelIdentificationPage();
          },
        ),
        GoRoute(
          path: '/register/tel_smsCode_page',
          builder: (BuildContext context, GoRouterState state) {
            return const TelSmsCodePage();
          },
        ),
        GoRoute(
          path: '/register/user_info_register_page',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfoRegisterPage();
          },
        ),
        GoRoute(
          path: '/bottom_bar',
          builder: (BuildContext context, GoRouterState state) {
            return const BottomBar();
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
            return const MyCardsListPage();
          },
        ),
        GoRoute(
          path: '/collections/collection_add_page',
          builder: (BuildContext context, GoRouterState state) {
            return const MyCardAddPage();
          },
        ),
        GoRoute(
          path: '/cards/cards_list_page',
          builder: (BuildContext context, GoRouterState state) {
            return const AllCardsListPage();
          },
        ),
        GoRoute(
          path: '/settings/setting_page',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingPage();
          },
        ),
        GoRoute(
          path: '/settings/user_info_edit_page',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfoEditPage();
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