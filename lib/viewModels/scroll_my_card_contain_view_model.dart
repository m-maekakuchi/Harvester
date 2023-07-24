import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../provider/my_card_serial_number_List_provider.dart';

final scrollMyCardContainViewModelProvider = StateNotifierProvider<ScrollMyCardContainViewModel, List<bool>>
  ((ref) => ScrollMyCardContainViewModel(ref));

class ScrollMyCardContainViewModel extends StateNotifier<List<bool>> {
  final Ref ref;
  ScrollMyCardContainViewModel(this.ref) : super([]);

  Future<void> init(List<CardMasterModel> cardMasterModelList) async {

    final myCardSerialNumberList = ref.read(myCardSerialNumberListProvider);

    // ロードされたマスターカードがマイカードに登録されているかの有無を取得
    List<bool> newList = [];
    for (CardMasterModel cardMasterModel in cardMasterModelList) {
      final myCardContain = myCardSerialNumberList.contains(cardMasterModel.serialNumber);
      newList.add(myCardContain);
    }
    state = newList;
    // print(newList.toString());
  }
}
