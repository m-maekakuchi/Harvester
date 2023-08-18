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
      createdAt: card['created_at'].toDate(),
    );
  }

  // ドキュメント参照からCardModelを取得
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

  // ドキュメント名からCardModelを取得
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

  // ドキュメント名からドキュメント内容を取得
  Future<Map<String, dynamic>?> getDocument(String docName) async {
    final docRef = db.collection("cards").doc(docName);
    Map<String, dynamic>? data;
    await docRef.get().then(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        data = doc.data();
      },
      onError: (e) {
        print("Error getting document: $e");
        data = null;
      }
    );
    return data;
  }

  // ドキュメント名から収集日のみ取得
  Future<DateTime?> getCollectDay(String docName) async {
    final docSnapshot = await db.collection("cards").doc(docName).get();
    final card = docSnapshot.data();

    DateTime? collectDay;
    if (card != null) {
      collectDay = card["collect_day"].toDate();
    } else {
      print("No such document.");
      collectDay = null;
    }
    return collectDay;
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

  // ドキュメント名からドキュメント削除
  Future<void> deleteDocument(String docName, Transaction transaction) async {
    final collectionRef = db.collection("cards");
    final cardDocRef = collectionRef.doc(docName);
    transaction.delete(cardDocRef);
  }

}