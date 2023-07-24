import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/card_master_repository.dart';
import '../repositories/card_repository.dart';
import '../viewModels/user_view_model.dart';

// ユーザーが登録済みのマイカードの番号リストを取得
Future<List<Map<String, dynamic>>?> getCardMasterNumberList(String uid, WidgetRef ref) async{
  List<Map<String, dynamic>>? cardNumberList;
  // ユーザーのカード情報を取得
  await ref.read(userViewModelProvider.notifier).getOnlyCardsFromFireStore(uid);
  // cardsフィールドのドキュメント参照リストを取得
  final List? cardDocRefList = ref.read(userViewModelProvider).cards;
  // cardsフィールドが存在し、配列が空ではないとき
  if (cardDocRefList != null && cardDocRefList.isNotEmpty) {
    cardNumberList = [];
    for (DocumentReference<Map<String, dynamic>> docRef in cardDocRefList) {
      // カードのドキュメント参照からカードモデルを取得
      final cardModel = await CardRepository().getFromFireStoreUsingDocRef(docRef);
      // cardsコレクションに、ドキュメント参照のドキュメントがちゃんと存在する場合
      if (cardModel != null) {
        final cardMasterDocRef = cardModel.cardMaster as DocumentReference<Map<String, dynamic>>;
        final cardMasterModel = await CardMasterRepository().getOneCardMaster(cardMasterDocRef);
        // card_masterコレクションに、ドキュメント参照のドキュメントがちゃんと存在する場合
        if (cardMasterModel != null) {
          cardNumberList.add(
            {
              "id": cardMasterModel.serialNumber,
              "favorite": cardModel.favorite
            }
          );
        }
      }
    }
  }
  return cardNumberList;
}
