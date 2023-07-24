import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_model.dart';
import '../viewModels/auth_view_model.dart';

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
        final deleteTask = desertRef.delete();
        deleteTasks.add(deleteTask);
      }
      // 全てのファイルの削除を並列処理で実行
      await Future.wait(deleteTasks);
    } on FirebaseException catch (e){
      print(e);
    }
  }

  // Storageから画像のURLを取得するメソッド
  Future<String?> downloadOneImageFromFireStore(String dir, String img, Ref ref) async{
    try {
      String uid = ref.read(authViewModelProvider.notifier).getUid();
      String fileFullPath = "$uid/$dir/$img";
      final storageRef = FirebaseStorage.instance.ref();
      final imageUrl = await storageRef.child(fileFullPath).getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e){
      print(e);
      return null;
    }
  }

  // Storageから画像のURLのリストを取得するメソッド
  Future<List<String>> downloadAllImageFromFireStore(String dir, WidgetRef ref) async{
    String uid = ref.read(authViewModelProvider.notifier).getUid();
    String fileFullPath = "$uid/$dir";
    final storageRef = FirebaseStorage.instance.ref();
    final pathReference = storageRef.child(fileFullPath);
    final listResult = await pathReference.listAll();

    List<String> result = [];
    for (var item in listResult.items) {
      result.add(await item.getDownloadURL());
    }
    return result;
  }

}