import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? firebaseAuthUid;
  final String? name;
  final String? address;
  final DateTime? birthday;
  final List<DocumentReference>? cards;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.firebaseAuthUid,
    this.name,
    this.address,
    this.birthday,
    this.cards,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      firebaseAuthUid: data?['firebase_auth_uid'],
      name: data?['name'],
      address: data?['address'],
      birthday: data?['birthday'].toDate(),
      cards: data?['cards'],
      createdAt: data?['created_at'].toDate(),
      updatedAt: data?['updated_at'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (firebaseAuthUid != null) 'firebase_auth_uid': firebaseAuthUid,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (birthday != null) 'birthday': birthday,
      if (cards != null) 'cards': cards,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
