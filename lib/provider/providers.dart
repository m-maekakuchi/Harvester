import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/address_master.dart';
import '../commons/app_const.dart';
import '../handlers/card_edit_handler.dart';
import '../handlers/user_handler.dart';

// ローカルに登録したマイカード情報を保持（例： [{"id": "00-101-A001", "favorite": true}]）
final myCardIdAndFavoriteListProvider = StateProvider((ref) => []);
// ローカルに登録したマイカード番号を保持
final StateProvider<List<String>> myCardNumberListProvider = StateProvider((ref) => []);
// ローディング状態を保持
final loadingIndicatorProvider = StateProvider((ref) => false);

/// bottom_bar
final bottomBarIndexProvider = StateProvider((ref) => 0);

/// ホーム画面
// 全国、地方ごと、都道府県ごとの全カード数のリスト
final allCardsLengthListProvider = StateProvider((ref) => []);

/// 全カード一覧画面
// リストの最後のドキュメント（全国タブと都道府県タブ用でリストで管理）
final StateProvider<List<DocumentSnapshot?>> allCardsPageLastDocumentProvider = StateProvider((ref) => List.filled(allCardTabTitleList.length, null));
// 選択された都道府県（初期値：東京都）
final allCardsPagePrefectureProvider = StateProvider((ref) => addressList[12]);

/// マイカード一覧画面
final myCardsPageFirstIndexProvider = StateProvider((ref) => List.filled(myCardTabTitleList.length, 0));
final myCardsPagePrefectureProvider = StateProvider((ref) => addressList[12]);

/// カード詳細画面
final carouselSliderIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

/// カード編集画面
final cardEditProvider = Provider((ref) => CardEdit(ref));  // refを使うためにProviderでラップ
final cardEditPageImageModelListProvider = StateProvider((ref) => []);
final cardEditPageCollectDayProvider = StateProvider((ref) => DateTime.now());
final cardEditPageFavoriteProvider = StateProvider((ref) => false);
final cardEditStateProvider = StateProvider((_) => const AsyncValue.data(null));

/// アカウント登録・編集画面
final userEditProvider = Provider((ref) => UserHandler(ref));
final userEditStateProvider = StateProvider((_) => const AsyncValue.data(null));

/// 設定画面
final colorProvider = StateProvider((ref) => 5);