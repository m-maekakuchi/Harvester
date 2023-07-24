import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/card_model.dart';

class CardRepository {
  final db = FirebaseFirestore.instance;

  Future<CardModel> getPhotosReferences(Map<String, dynamic> card) async{
    List? list = card['photos'];
    List<DocumentReference<Map<String, dynamic>>> docRefList = [];
    if (list != null && list.isNotEmpty) {
      // for(DocumentReference<Map<String, dynamic>> docRef in list) {
      await Future.forEach(list, (docRef) async {
        docRefList.add(docRef);
      });
    }
    return CardModel(
      cardMaster: card['card_master'],
      collectDay: card['collect_day'].toDate(),
      favorite: card['favorite'],
      photos: docRefList.isEmpty ? null : docRefList,
    );
  }

  // ドキュメント参照から取得
  Future<CardModel?> getFromFireStoreUsingDocRef(DocumentReference<Map<String, dynamic>> docRef) async {
    final docSnapshot = await docRef.get();
    final card = docSnapshot.data();

    CardModel? cardModel;
    if (card != null) {
      cardModel = await getPhotosReferences(card);
    } else {
      print("No such document.");
      cardModel = null;
    }
    return cardModel;
  }

  // ドキュメント名から取得
  Future<CardModel?> getFromFireStoreUsingDocName(String docName) async {
    final docSnapshot = await db.collection("cards").doc(docName).get();
    final card = docSnapshot.data();

    CardModel? cardModel;
    if (card != null) {
      cardModel = await getPhotosReferences(card);
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