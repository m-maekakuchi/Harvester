import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';

final cardMasterOptionListProvider = StateNotifierProvider<CardMaterOptionViewModel, List<String>>
  ((ref) => CardMaterOptionViewModel());

class CardMaterOptionViewModel extends StateNotifier<List<String>> {
  CardMaterOptionViewModel() : super([]);

  Future<void> getCardMasterOption(List<CardMasterModel> list) async {
    List<String> cardMasterOptionList = [];
    for (CardMasterModel item in list) {
      cardMasterOptionList.add("${item.serialNumber}　　${item.city}");
    }
    state = cardMasterOptionList;
  }
}