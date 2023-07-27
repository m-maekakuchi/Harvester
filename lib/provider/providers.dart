import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/address_master_list.dart';
import '../commons/app_const.dart';

/// bottom_bar
final bottomBarIndexProvider = StateProvider((ref) => 0);

/// 全カード一覧画面
// リストの最後のドキュメント（全国タブと都道府県タブ用でリストで管理）
final StateProvider<List<DocumentSnapshot?>> allCardsListLastDocumentProvider = StateProvider((ref) => List.filled(allCardTabTitleList.length, null));
// 選択された都道府県（初期値：東京都）
final allCardsPagePrefectureProvider = StateProvider((ref) => addressList[12]);