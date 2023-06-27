import '../commons/address_master_list.dart';
import '../models/card_master_model.dart';

// マスターカードを選択する欄に表示する選択肢（カード番号と市町村）
Map<String, List<String>> makeCardMasterOptionList(List<CardMasterModel> list) {
  Map<String, List<String>> numberAndCityMap = {};

  for (var value in list) {
    if (numberAndCityMap.containsKey(value.prefecture)) {
      numberAndCityMap[value.prefecture]!.add("${value.serialNumber}　${value.city}");
    } else {
      numberAndCityMap[value.prefecture] = ["${value.serialNumber}　${value.city}"];
    }
  }

  // 都道府県順に並び替え
  Map<String, List<String>> sortedNumberAndCityMap = Map.fromEntries(addressList.map((key) => MapEntry(key, numberAndCityMap[key]!)));
  return sortedNumberAndCityMap;
}

