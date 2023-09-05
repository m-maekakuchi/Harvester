import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/local_storage_repository.dart';
import '../viewModels/auth_view_model.dart';
import 'card_master_handler.dart';

Future<List<Map<String, dynamic>>?> fetchMyCardIdAndFavoriteFromLocalOrDB (WidgetRef ref) async {
  // Hiveでローカルからマイカードの番号を取得
  List<Map<String, dynamic>>? localMyCardInfoList = await LocalStorageRepository().fetchMyCardIdAndFavorites();
  print("ローカルのマイカード情報：${localMyCardInfoList.toString()}");
  if (localMyCardInfoList != null) return localMyCardInfoList;

  // ローカルから取得できない場合、FireStoreから取得
  // cardsフィールドがない又はcardsフィールドの配列が空の場合、戻り値はnull
  final uid = ref.watch(authViewModelProvider.notifier).getUid();
  List<Map<String, dynamic>>? dbMyCardInfoList = await getCardMasterNumberList(uid, ref);
  print("上がnullの場合DBから取得したあとのマイカード情報：${dbMyCardInfoList.toString()}");

  // DBからデータが取得できたとき、ローカルにマイカード情報の登録がないのにDBにはあるという状況なので、
  // DBから取得した情報をローカルに登録しておく
  if (dbMyCardInfoList != null) {
    await LocalStorageRepository().putMyCardIdAndFavorites(dbMyCardInfoList);
  }
  return dbMyCardInfoList;
}