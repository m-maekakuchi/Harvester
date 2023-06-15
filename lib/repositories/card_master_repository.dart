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

  Future<List<CardMasterModel>> getCardMasters(String prefecture) async {

    final List<CardMasterModel> cardMasterList = [];
    // const card = Card(
    //   cardMasterList: [
    //     CardMaster(
    //
    //     ),
    //   ],
    //   photos: [
    //
    //   ],
    //   collectionDay: "2023/5/6",
    //   createdAt
    // );
    return cardMasterList;
  }
}