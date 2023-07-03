import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String? firebaseAuthUid;
  final String? fileName;
  final String? filePath;
  final DateTime? createdAt;

  PhotoModel({
    this.firebaseAuthUid,
    this.fileName,
    this.filePath,
    this.createdAt,
  });

  factory PhotoModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PhotoModel(
      firebaseAuthUid: data?['firebase_auth_uid'],
      fileName: data?['file_name'],
      filePath: data?['file_path'],
      createdAt: data?['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (firebaseAuthUid != null) 'firebase_auth_uid': firebaseAuthUid,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}
