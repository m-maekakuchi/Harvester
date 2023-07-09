import 'package:firebase_storage/firebase_storage.dart';

import '../models/image_model.dart';

class ImageRepository {

  Future uploadImageToFirebase(List<ImageModel> imageModelList) async {
    try {
      final List<Future> uploadTasks = [];
      for (ImageModel imageModel in imageModelList) {
        // アップロードしたいファイルのパス
        Reference storageRef = FirebaseStorage.instance.ref().child(imageModel.filePath!);
        // アップロードしたいファイルのメタデータ
        final metadata = SettableMetadata(contentType: "image/jpeg");

        final uploadTask = storageRef
          .child(imageModel.fileName!)
          .putData(imageModel.imageFile!, metadata);
        uploadTasks.add(uploadTask);
      }
      // 全てのファイルのアップロードを並列処理で実行
      await Future.wait(uploadTasks);
    } on FirebaseException catch (e){
      print(e);
    }
  }

  Future<void> deleteImageFromFireStore(List<ImageModel> imageModelList) async{
    final deleteTasks = <Future>[];
    try {
      for (ImageModel imageModel in imageModelList) {
        // 削除したいファイルのパス
        final desertRef = FirebaseStorage.instance.ref().child("${imageModel.filePath!}/${imageModel.fileName}");
        // await desertRef.delete();
        final deleteTask = desertRef.delete();
        deleteTasks.add(deleteTask);
      }
      // 全てのファイルの削除を並列処理で実行
      await Future.wait(deleteTasks);
    } on FirebaseException catch (e){
      print(e);
    }
  }

}