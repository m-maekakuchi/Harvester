import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/local_storage_repository.dart';
import '../viewModels/auth_view_model.dart';
import 'card_master_handler.dart';

Future<List<Map<String, dynamic>>?> fetchMyCardIdAndFavoriteFromLocalOrDB (WidgetRef ref) async {
  // Hiveでローカルからマイカードの番号を取得
  List<Map<String, dynamic>>? localMyCardInfoList = await LocalStorageRepository().fetchMyCardIdAndFavorites();
  print("ローカルのマイカード情報：${localMyCardInfoList.toString()}");

  // ローカルから取得できない場合、FireStoreから取得
  // cardsフィールドがない又はcardsフィールドの配列が空の場合、戻り値はnull
  final uid = ref.watch(authViewModelProvider.notifier).getUid();
  localMyCardInfoList ??= await getCardMasterNumberList(uid, ref);
  print("上がnullの場合DBから取得したあとのマイカード情報：${localMyCardInfoList.toString()}");

  return localMyCardInfoList;
}