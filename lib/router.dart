import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/viewModels/auth_view_model.dart';
import 'package:harvester/views/pages/bottom_bar.dart';
import 'package:harvester/views/pages/cards/card_detail_page.dart';
import 'package:harvester/views/pages/register/tel_sms_code_page.dart';
import 'package:harvester/views/pages/welcome_page.dart';
import 'package:harvester/views/pages/cards/all_cards_list_page.dart';
import 'package:harvester/views/pages/collections/my_card_edit_page.dart';
import 'package:harvester/views/pages/collections/my_cards_list_page.dart';
import 'package:harvester/views/pages/collections/my_card_add_page.dart';
import 'package:harvester/views/pages/home_page.dart';
import 'package:harvester/views/pages/photos/photos_list_page.dart';
import 'package:harvester/views/pages/settings/setting_page.dart';
import 'package:harvester/views/pages/settings/profile_edit_page.dart';
import 'package:harvester/views/pages/register/tel_identification_page.dart';
import 'package:harvester/views/pages/register/user_info_page.dart';
import 'commons/redirect_path.dart';


Provider<GoRouter> router() {
  return Provider((ref) =>
    GoRouter(
      redirect: (context, state) async {
        // return '/register/user_info_page';

        // authControllerProviderに変更があった場合に動くイメージ
        final auth = ref.watch(authViewModelProvider);
        bool isSignedIn = auth.value != null;

        // サインアウトするときのコード
        // ref.watch(authViewModelProvider.notifier).signOut();

        // AuthControllerメソッド呼ぶときnotifierつける
        final user = ref.watch(authViewModelProvider.notifier).getCurrentUser();
        String requestPagePath = state.subloc;
        print("リダイレクトパス：$requestPagePath");
        // アクセスしようとしているパスがnotLoginSignInPathに入ってるか
        final goingToSignIn = RedirectPath.notLoginSignInPath.contains(requestPagePath);
        // サインインしてない && notLoginSignInPath以外に入ろうとしてる
        if (!isSignedIn && !goingToSignIn) {
          print('----サインインしていない && notLoginSignInPathに入ろうとしている----');
          return '/';
        } else if (isSignedIn) {
          print('----サインインしている----');
          // サインインしてるのに、トップとか電話番号認証に入ろうとしてる
          if (requestPagePath == '/' || goingToSignIn) {
            print('----入ってはいけないページにアクセスしようとしている。----');
            final result = await user!.getIdTokenResult(true);
            print("*****************************************************");
            print(result);
            print("*****************************************************");
            await ref.watch(authViewModelProvider.notifier).reload();
            final registerCustomState = result.claims!['registerStatus'];
            print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
            print("ユーザー情報の登録が完了済か: $registerCustomState");
            print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
            if (registerCustomState == 1) {
              return '/bottom_bar';
            } else {
              return '/register/user_info_page';
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
          path: '/register/user_info_page',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfoPage();
          },
        ),
        GoRoute(
          // path: '/BasePage',
          path: '/bottom_bar',
          builder: (BuildContext context, GoRouterState state) {
            // return const BasePage();
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
          path: '/cards/card_detail_page',
          builder: (BuildContext context, GoRouterState state) {
            return const CardDetailPage();
          },
        ),
        GoRoute(
          path: '/cards/my_card_edit_page',
          builder: (BuildContext context, GoRouterState state) {
            return const MyCardEditPage();
          },
        ),
        GoRoute(
          path: '/settings/setting_page',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingPage();
          },
        ),
        GoRoute(
          path: '/settings/profile_edit_page',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileEditePage();
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