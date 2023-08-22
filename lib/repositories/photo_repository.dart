import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/photo_model.dart';

class PhotoRepository {
  final db = FirebaseFirestore.instance;

  Future<PhotoModel?> getFromFireStore(DocumentReference<Map<String, dynamic>> docRef) async {
    final ref = docRef.withConverter(
      fromFirestore: PhotoModel.fromFirestore,
      toFirestore: (PhotoModel photoModel, _) => photoModel.toFirestore(),
    );
    final docSnapshot = await ref.get();
    final photoModel = docSnapshot.data();
    return photoModel;
  }

  Future<List<DocumentReference>> setToFireStore(List<PhotoModel> list, Transaction transaction) async {
    final List<DocumentReference> docList = [];
    final collectionRef = db.collection("photos");

    for(var photoModel in list) {
      final docRef = collectionRef
        .withConverter(
          fromFirestore: PhotoModel.fromFirestore,
          toFirestore: (PhotoModel photoModel, options) => photoModel.toFirestore(),
        )
        .doc();
      docList.add(docRef);
      transaction.set(docRef, photoModel);
    }
    return docList;
  }

  // ドキュメント参照で、ドキュメントを削除
  Future<void> deleteDocument(List<DocumentReference> docRefList, Transaction transaction) async {
    for(var docRef in docRefList) {
      transaction.delete(docRef);
    }
  }
}