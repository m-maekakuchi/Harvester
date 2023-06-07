import 'package:cloud_firestore/cloud_firestore.dart';

class Card {
  final List<DocumentReference>? cardMaster;
  final List<DocumentReference>? photos;
  final DateTime? collectDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Card({
    this.cardMaster,
    this.photos,
    this.collectDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Card.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Card(
      cardMaster: data?['card_master'],
      photos: data?['photos'],
      collectDate: data?['collect_date'].toDate(),
      createdAt: data?['created_at'].toDate(),
      updatedAt: data?['updated_at'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (cardMaster != null) 'card_master': cardMaster,
      if (photos != null) 'photos': photos,
      if (collectDate != null) 'created_at': collectDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
