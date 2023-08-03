import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/app_const.dart';
import '../models/card_master_model.dart';
import '../provider/providers.dart';

class CardMasterRepository {

  final collRef = FirebaseFirestore.instance.collection("card_master").withConverter(
    fromFirestore: CardMasterModel.fromFirestore,
    toFirestore: (CardMasterModel city, _) => city.toFirestore(),
  );

  // 取得したい数分だけドキュメントを取得
  Future<List<CardMasterModel>> getLimitCountCardMasters(WidgetRef ref, int tabIndex) async {
    final lastDocument = ref.read(allCardsPageLastDocumentProvider)[tabIndex];
    final selectedPrefecture = ref.read(allCardsPagePrefectureProvider);

    final List<CardMasterModel> cardMasterList = [];

    var query = collRef.limit(loadingNum);
    // 都道府県タブが選択中であれば絞り込み検索
    if (tabIndex == 1) {
      query = query.where("prefecture", isEqualTo: selectedPrefecture);
    }
    // 前回取得したドキュメントの次のドキュメントから取得
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();
    for (var docSnapshot in querySnapshot.docs) {
      cardMasterList.add(docSnapshot.data());
    }

    ref.read(allCardsPageLastDocumentProvider.notifier).state[tabIndex] = querySnapshot.docs.last;

    return cardMasterList;
  }

  // ドキュメント参照を取得
  Future<DocumentReference> getCardMasterRef(String cardNumber) async {
    return collRef.doc(cardNumber);
  }

  // ドキュメント参照から、マスターカード1枚を取得
  Future<CardMasterModel?> getOneCardMaster(DocumentReference<Map<String, dynamic>> docRef) async {
    final ref = docRef.withConverter(
      fromFirestore: CardMasterModel.fromFirestore,
      toFirestore: (CardMasterModel cardMasterModel, _) => cardMasterModel.toFirestore(),
    );
    final docSnapshot = await ref.get();
    final cardMasterModel = docSnapshot.data();
    return cardMasterModel;
  }
}