import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../provider/my_card_info_list_provider.dart';
import '../provider/my_card_number_list_provider.dart';

final scrollFavoriteViewModelProvider = StateNotifierProvider<ScrollFavoriteViewModel, List<bool?>>
  ((ref) => ScrollFavoriteViewModel(ref));

class ScrollFavoriteViewModel extends StateNotifier<List<bool?>> {
  final Ref ref;
  ScrollFavoriteViewModel(this.ref) : super([]);

  Future<void> init(List<CardMasterModel> cardMasterModelList) async {

    final myCardInfoList = ref.read(myCardInfoListProvider);
    final myCardSerialNumberList = ref.read(myCardNumberListProvider);

    // ロードされたマスターカードがマイカードに登録されているかの有無を取得
    List<bool?> myFavoriteList = [];
    for (CardMasterModel cardMasterModel in cardMasterModelList) {
      if (myCardSerialNumberList.contains(cardMasterModel.serialNumber)) {
        int index = myCardInfoList.indexWhere((element) => element["id"] == cardMasterModel.serialNumber);
        myFavoriteList.add(myCardInfoList[index]["favorite"]);
      } else {
        myFavoriteList.add(null);
      }
    }
    state = myFavoriteList;
  }
}