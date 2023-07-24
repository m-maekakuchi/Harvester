import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvester/models/card_master_model.dart';
import 'package:harvester/repositories/photo_repository.dart';
import 'package:harvester/viewModels/auth_view_model.dart';

import '../models/card_model.dart';
import '../repositories/card_repository.dart';
import '../repositories/image_repository.dart';

final scrollImageUrlListProvider = StateNotifierProvider<ScrollImageUrlListViewModel, List<String?>>
  ((ref) => ScrollImageUrlListViewModel(ref));

class ScrollImageUrlListViewModel extends StateNotifier<List<String?>> {
  final Ref ref;
  ScrollImageUrlListViewModel(this.ref) : super([]);

  ImageRepository repository = ImageRepository();

  // マイカードに含まれていれば、そのマイカードに登録されている1枚目の画像のURLをリストに追加
  // 含まれていなければnullを追加
  Future<void> init(List<CardMasterModel> cardMasterModelList, List<bool> myCardContainList) async {
    final uid = ref.read(authViewModelProvider.notifier).getUid();
    List<String?> imgList = [];

    int i = 0;
    /// ListのforEachでasync, awaitを使用するときはFuture.forEachじゃないと処理順番が期待通りにならない
    await Future.forEach(cardMasterModelList, (item) async {
      if (myCardContainList[i]) {
        CardModel? cardModel = await CardRepository().getFromFireStoreUsingDocName("$uid${cardMasterModelList[i].serialNumber}");
        if (cardModel != null && cardModel.photos!.isNotEmpty) {
          final photoFirstDocRef = cardModel.photos![0] as DocumentReference<Map<String, dynamic>>;
          final photoModel = await PhotoRepository().getFromFireStore(photoFirstDocRef);
          if (photoModel != null) {
            final imgUrl = await ImageRepository().downloadOneImageFromFireStore(cardMasterModelList[i].serialNumber, photoModel.fileName!, ref);
            imgList.add(imgUrl);
          } else {
            imgList.add(null);
          }
        } else {
          imgList.add(null);
        }
      } else {
        imgList.add(null);
      }
      i++;
    });
    state = imgList;
  }
}