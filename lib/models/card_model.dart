import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final DocumentReference? cardMaster;
  final List<DocumentReference>? photos;
  final bool? favorite;
  final DateTime? collectDay;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CardModel({
    this.cardMaster,
    this.photos,
    this.favorite,
    this.collectDay,
    this.createdAt,
    this.updatedAt,
  });

  factory CardModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CardModel(
      cardMaster: data?['card_master'],
      photos: data?['photos'],
      favorite: data?['favorite'],
      collectDay: data?['collect_day'].toDate(),
      createdAt: data?['created_at'].toDate(),
      updatedAt: data?['updated_at'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (cardMaster != null) 'card_master': cardMaster,
      if (photos != null) 'photos': photos,
      if (favorite != null) 'favorite': favorite,
      if (collectDay != null) 'collect_day': collectDay,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
