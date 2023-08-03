import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/address_master_list.dart';
import '../commons/app_const.dart';

// ローカルに登録したマイカード情報を保持（例： [{"id": "00-101-A001", "favorite": true}]）
final myCardIdAndFavoriteListProvider = StateProvider((ref) => []);
// ローカルに登録したマイカード番号を保持
final myCardNumberListProvider = StateProvider((ref) => []);

/// bottom_bar
final bottomBarIndexProvider = StateProvider((ref) => 0);

/// 全カード一覧画面
// リストの最後のドキュメント（全国タブと都道府県タブ用でリストで管理）
final StateProvider<List<DocumentSnapshot?>> allCardsPageLastDocumentProvider = StateProvider((ref) => List.filled(allCardTabTitleList.length, null));
// 選択された都道府県（初期値：東京都）
final allCardsPagePrefectureProvider = StateProvider((ref) => addressList[12]);

/// カード詳細画面
final carouselSliderIndexProvider = StateProvider.autoDispose<int>((ref) => 0);