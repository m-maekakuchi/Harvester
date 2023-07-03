import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/photo_model.dart';

class PhotoRepository {
  final db = FirebaseFirestore.instance;

  Future<List<DocumentReference>> setToFireStore(List<PhotoModel> list) async {
    final List<DocumentReference> docList = [];
    for(var photoModel in list) {
      final docRef = db
        .collection("photos")
        .withConverter(
          fromFirestore: PhotoModel.fromFirestore,
          toFirestore: (PhotoModel photoModel, options) => photoModel.toFirestore(),
        )
        .doc();
      docList.add(docRef);
      await docRef.set(photoModel).then(
        (value) => print("DocumentSnapshot successfully set!"),
        onError: (e) {
          print("Error setting document $e");
        }
      );
    }
    return docList;
  }
}