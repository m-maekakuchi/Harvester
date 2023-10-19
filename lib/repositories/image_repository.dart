import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_model.dart';
import '../viewModels/auth_view_model.dart';

class ImageRepository {
  final storageRef = FirebaseStorage.instance.ref();

  Future uploadImageToStorage(List<ImageModel> imageModelList) async {
    try {
      final List<Future> uploadTasks = [];
      for (ImageModel imageModel in imageModelList) {
        // アップロードしたいファイルのパス
        Reference imageRef = storageRef.child(imageModel.filePath!);
        // アップロードしたいファイルのメタデータ
        final metadata = SettableMetadata(contentType: "image/jpeg");

        final uploadTask = imageRef
          .child(imageModel.fileName!)
          .putData(imageModel.imageFile!, metadata);
        uploadTasks.add(uploadTask);
      }
      // throw FirebaseException(plugin: '');
      // 全てのファイルのアップロードを並列処理で実行
      await Future.wait(uploadTasks);
    } on FirebaseException {
      debugPrint("*****storageへの画像の登録に失敗しました。*****");
      rethrow;
    }
  }

  Future<void> deleteImageFromStorage(List<ImageModel> imageModelList) async{
    final deleteTasks = <Future>[];
    try {
      for (ImageModel imageModel in imageModelList) {
        // 削除したいファイルのパス
        final imageRef = storageRef.child("${imageModel.filePath!}/${imageModel.fileName}");
        final deleteTask = imageRef.delete();
        deleteTasks.add(deleteTask);
      }
      // 全てのファイルの削除を並列処理で実行
      await Future.wait(deleteTasks);
    } on FirebaseException {
      debugPrint("*****storageの画像の削除に失敗しました。*****");
      rethrow;
    }
  }

  // ディレクトリ内の画像をすべて削除
  Future<void> deleteDirectoryFromStorage(String path) async{
    try {
      await FirebaseStorage.instance.ref(path).listAll().then((value) async {
        await Future.forEach(value.items, (element) async {
          await FirebaseStorage.instance.ref(element.fullPath).delete();  // この行にawaitつけると画像一つずつ消すので時間かかる？
        });
      });
    } on FirebaseException {
      debugPrint("*****storageのディレクトリ内の画像（ユーザーが登録したもの全て）の削除に失敗しました*****");
      rethrow;
    }
  }

  // Storageから画像のURLを取得するメソッド
  Future<String?> downloadOneImageFromStorage(String dir, String img, WidgetRef ref) async{
    try {
      String uid = ref.read(authViewModelProvider.notifier).getUid();
      String fileFullPath = "$uid/$dir/$img";
      final imageUrl = await storageRef.child(fileFullPath).getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  // Storageから画像のURLのリストを取得するメソッド
  // Future<List<String>> downloadAllImageFromFireStore(String dir, WidgetRef ref) async{
  //   String uid = ref.read(authViewModelProvider.notifier).getUid();
  //   String fileFullPath = "$uid/$dir";
  //   final pathReference = storageRef.child(fileFullPath);
  //   final listResult = await pathReference.listAll();
  //
  //   List<String> result = [];
  //   for (var item in listResult.items) {
  //     result.add(await item.getDownloadURL());
  //   }
  //   return result;
  // }

  //  Storageから画像をメモリ（UInt8List）にダウンロード
  Future<Uint8List?> downloadImageToMemoryFromStorage(String dir, String img, WidgetRef ref) async {
    String uid = ref.read(authViewModelProvider.notifier).getUid();
    final islandRef = storageRef.child("$uid/$dir/$img");
    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      return data;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

}