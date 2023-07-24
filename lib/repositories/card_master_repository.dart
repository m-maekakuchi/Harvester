import 'package:cloud_firestore/cloud_firestore.dart';

import '../commons/app_const_num.dart';
import '../models/card_master_model.dart';

class CardMasterRepository {

  DocumentSnapshot? _lastDocument;

  final ref = FirebaseFirestore.instance.collection("card_master").withConverter(
    fromFirestore: CardMasterModel.fromFirestore,
    toFirestore: (CardMasterModel city, _) => city.toFirestore(),
  );

  // 取得したい数分だけマスターカードコレクションからドキュメントを取得
  Future<List<CardMasterModel>> getLimitCountCardMasters() async {
    final List<CardMasterModel> cardMasterList = [];
    var query = ref.limit(loadingNum);

    // 前回取得したドキュメントの次のドキュメントから取得
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final querySnapshot = await query.get();
    for (var docSnapshot in querySnapshot.docs) {
      cardMasterList.add(docSnapshot.data());
    }
    _lastDocument = querySnapshot.docs.last;

    return cardMasterList;
  }

  // ドキュメント参照を取得
  Future<DocumentReference> getCardMasterRef(String cardNumber) async {
    return ref.doc(cardNumber);
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