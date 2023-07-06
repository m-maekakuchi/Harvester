import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/card_master_model.dart';

class CardMasterRepository {

  final ref = FirebaseFirestore.instance.collection("card_master").withConverter(
    fromFirestore: CardMasterModel.fromFirestore,
    toFirestore: (CardMasterModel city, _) => city.toFirestore(),
  );

  Future<List<CardMasterModel>> getAllCardMasters() async {
    final List<CardMasterModel> cardMasterList = [];
    final querySnapshot = await ref.get();
    for (var docSnapshot in querySnapshot.docs) {
      cardMasterList.add(docSnapshot.data());
    }
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