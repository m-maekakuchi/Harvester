import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? firebaseAuthUid;
  final String? name;
  final int? addressIndex;
  final DateTime? birthday;
  final List<DocumentReference>? cards;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.firebaseAuthUid,
    this.name,
    this.addressIndex,
    this.birthday,
    this.cards,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      firebaseAuthUid: data?['firebase_auth_uid'],
      name: data?['name'],
      addressIndex: data?['addressIndex'],
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
      if (addressIndex != null) 'addressIndex': addressIndex,
      if (birthday != null) 'birthday': birthday,
      if (cards != null) 'cards': cards,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
