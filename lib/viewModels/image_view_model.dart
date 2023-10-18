import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_model.dart';
import '../repositories/image_repository.dart';

final imageListProvider = StateNotifierProvider<ImageListViewModel, List<ImageModel>>
  ((ref) => ImageListViewModel());

class ImageListViewModel extends StateNotifier<List<ImageModel>> {
  ImageListViewModel() : super([]);

  ImageRepository repository = ImageRepository();

  Future<void> init() async {
    state = [];
  }

  Future<void> add(ImageModel image) async{
    /// 今の時点のstateを確保　新しいList<ImageModel>を定義して代入
    /// 引数から与えられたimageを追加する
    /// stateに再定義したリストを代入
    List<ImageModel> imageList = state;
    /// 4枚以上リストに登録できないように設定
    if (imageList.length > 4) return;

    imageList.add(image);
    state = [...imageList];
  }

  Future<void> remove(int index) async{
    List<ImageModel> imageList = state;
    imageList.removeAt(index);
    state = [...imageList];
  }

  Future<void> uploadImageToFirebase() async {
    try {
      await repository.uploadImageToFirebase(state);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImageFromFireStore() async {
    try {
      await repository.deleteImageFromFireStore(state);
    } catch (e) {
      rethrow;
    }
  }
}