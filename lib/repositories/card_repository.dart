import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvester/models/card_model.dart';

class CardRepository {
  final db = FirebaseFirestore.instance;

  Future<DocumentReference> setToFireStore(CardModel model, String docName) async {
    final docRef = db
      .collection("cards")
      .withConverter(
        fromFirestore: CardModel.fromFirestore,
        toFirestore: (CardModel cardModel, options) => cardModel.toFirestore(),
      )
      .doc(docName);
    await docRef.set(model).then(
      (value) => print("DocumentSnapshot successfully set!"),
      onError: (e) => print("Error setting document $e")
    );
    return db.collection("cards").doc(docName);
  }
}