import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/card_model.dart';

class CardRepository {
  final db = FirebaseFirestore.instance;

  Future<CardModel?> getFromFireStore(DocumentReference<Map<String, dynamic>> docRef) async {
    final docSnapshot = await docRef.get();
    final card = docSnapshot.data();

    CardModel? cardModel;
    if (card != null) {
      List? list = card['photos'];
      List<DocumentReference<Map<String, dynamic>>> docRefList = [];
      if (list != null && list.isNotEmpty) {
        for(DocumentReference<Map<String, dynamic>> docRef in list) {
          docRefList.add(docRef);
        }
      }
      cardModel = CardModel(
        cardMaster: card['card_master'],
        collectDay: card['collect_day'].toDate(),
        favorite: card['favorite'],
        photos: docRefList.isEmpty ? null : docRefList,
      );
    } else {
      print("No such document.");
      cardModel = null;
    }
    return cardModel;
  }

  Future<DocumentReference> setToFireStore(CardModel cardModel, String docName, Transaction transaction) async {
    final collectionRef = db.collection("cards");

    final docRef = collectionRef
      .withConverter(
        fromFirestore: CardModel.fromFirestore,
        toFirestore: (CardModel cardModel, options) => cardModel.toFirestore(),
      )
      .doc(docName);
    transaction.set(docRef, cardModel);
    return db.collection("cards").doc(docName);
  }
}