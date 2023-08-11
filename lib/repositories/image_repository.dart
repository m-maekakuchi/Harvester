import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_model.dart';
import '../viewModels/auth_view_model.dart';

class ImageRepository {
  final storageRef = FirebaseStorage.instance.ref();

  Future uploadImageToFirebase(List<ImageModel> imageModelList) async {
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
        final imageRef = storageRef.child("${imageModel.filePath!}/${imageModel.fileName}");
        final deleteTask = imageRef.delete();
        deleteTasks.add(deleteTask);
      }
      // 全てのファイルの削除を並列処理で実行
      await Future.wait(deleteTasks);
    } on FirebaseException catch (e){
      print(e);
    }
  }

  // ディレクトリ内の画像をすべて削除
  Future<void> deleteDirectoryFromFireStore(String path) async{
    try {
      await FirebaseStorage.instance.ref(path).listAll().then((value) {
        for (var element in value.items) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        }
      });
    } on FirebaseException catch (e){
      print(e);
    }
  }

  // Storageから画像のURLを取得するメソッド
  Future<String?> downloadOneImageFromFireStore(String dir, String img, WidgetRef ref) async{
    try {
      String uid = ref.read(authViewModelProvider.notifier).getUid();
      String fileFullPath = "$uid/$dir/$img";
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
    final pathReference = storageRef.child(fileFullPath);
    final listResult = await pathReference.listAll();

    List<String> result = [];
    for (var item in listResult.items) {
      result.add(await item.getDownloadURL());
    }
    return result;
  }

  //  Storageから画像をメモリ（UInt8List）にダウンロード
  Future<Uint8List?> downloadImageToMemoryFromFireStore(String dir, String img, WidgetRef ref) async {
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