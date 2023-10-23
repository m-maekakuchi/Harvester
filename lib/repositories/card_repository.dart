import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class CardRepository {
  final db = FirebaseFirestore.instance;

  Future<CardModel> getPhotosReferences(Map<String, dynamic> card) async{
    List? list = card['photos'];
    List<DocumentReference<Map<String, dynamic>>>? docRefList;
    if (list != null && list.isNotEmpty) {
      docRefList = [];
      await Future.forEach(list, (docRef) async {
        docRefList!.add(docRef);
      });
    }
    return CardModel(
      cardMaster: card['card_master'],
      collectDay: card['collect_day'].toDate(),
      favorite: card['favorite'],
      photos: docRefList,
      createdAt: card['created_at'].toDate(),
    );
  }

  // ドキュメント参照からCardModelを取得
  Future<CardModel?> getFromFireStoreUsingDocRef(DocumentReference<Map<String, dynamic>> docRef) async {
    try {
      // throw FirebaseException(plugin: "");
      final docSnapshot = await docRef.get();
      final card = docSnapshot.data();

      CardModel? cardModel;
      if (card != null) {
        cardModel = await getPhotosReferences(card);
      }
      return cardModel;
    } on FirebaseException {
      debugPrint("*****マイカードの取得に失敗しました*****");
      rethrow;
    }
  }

  // ドキュメント名からCardModelを取得
  Future<CardModel?> getFromFireStoreUsingDocName(String docName) async {
    try {
      // throw FirebaseException(plugin: "");
      final docSnapshot = await db.collection("cards").doc(docName).get();
      final card = docSnapshot.data();

      CardModel? cardModel;
      if (card != null) {
        cardModel = await getPhotosReferences(card);
      }
      return cardModel;
    } on FirebaseException {
      debugPrint("*****マイカードの取得に失敗しました*****");
      rethrow;
    }
  }

  // ドキュメント名からドキュメントを取得
  Future<Map<String, dynamic>?> getDocument(String docName) async {
    final docRef = db.collection("cards").doc(docName);
    try {
      final doc = await docRef.get();
      return doc.data();
    } on FirebaseException {
      debugPrint("*****cardsコレクションからドキュメントを取得できませんでした*****");
      rethrow;
    }
  }

  // ドキュメント名から収集日のみ取得
  // Future<DateTime?> getCollectDay(String docName) async {
  //   final docSnapshot = await db.collection("cards").doc(docName).get();
  //   final card = docSnapshot.data();
  //
  //   DateTime? collectDay;
  //   if (card != null) {
  //     collectDay = card["collect_day"].toDate();
  //   } else {
  //     print("No such document.");
  //     collectDay = null;
  //   }
  //   return collectDay;
  // }

  Future<DocumentReference> setToFireStore(CardModel cardModel, String docName, Transaction transaction) async {
    final collectionRef = db.collection("cards");

    final docRef = collectionRef
      .withConverter(
        fromFirestore: CardModel.fromFirestore,
        toFirestore: (CardModel cardModel, options) => cardModel.toFirestore(),
      )
      .doc(docName);
    try {
      // throw FirebaseException(plugin: '');
      transaction.set(docRef, cardModel);
      return db.collection("cards").doc(docName);
    } on FirebaseException {
      debugPrint("*****cardsコレクションへのドキュメント登録に失敗しました*****");
      rethrow;
    }
  }

  // ドキュメント名を使ってドキュメント削除
  Future<void> deleteDocument(String docName, Transaction transaction) async {
    final collectionRef = db.collection("cards");
    final cardDocRef = collectionRef.doc(docName);
    try {
      transaction.delete(cardDocRef);
    } on FirebaseException {
      debugPrint("*****cardsコレクション内のドキュメント削除に失敗しました*****");
      rethrow;
    }
  }

}