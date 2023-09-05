import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/address_master.dart';
import '../commons/app_const.dart';
import '../commons/card_master_option_list.dart';
import '../commons/irregular_card_number.dart';
import '../provider/providers.dart';

final prefectureLength = addressList.length;

// 全国、地方ごと、都道府県ごとの全カード数のリストを生成
List<int> createAllCardLengthList() {
  List<int> result = [];

  int regionCardsLength = 0;      // 地方毎のカード数
  int regionPrefectureCount = 0;  // 地方の切り替わりを判定するためのカウント
  int index = 0;
  List<int> regionCardLengthList = [];    // 地方のカード数を格納するリスト
  List<int> prefectureCardLengthList =[]; // 都道府県ごとのカード数を格納するリスト

  for (int i = 0; i < prefectureLength; i++) {
    regionPrefectureCount++;
    regionCardsLength += cardMasterOptionStrList[i].length;
    if(regionLengthMap.values.elementAt(index) == regionPrefectureCount) {
      regionCardLengthList.add(regionCardsLength);
      index++;
      regionPrefectureCount = 0;
      regionCardsLength = 0;
    }

    prefectureCardLengthList.add(cardMasterOptionStrList[i].length);
  }
  result.add(cardMasterNum);
  result.addAll(regionCardLengthList);
  result.addAll(prefectureCardLengthList);
  return result;
}

// 全国、地方ごと、都道府県ごとのマイカード数のリストを生成
List<int> createMyCardLengthList(WidgetRef ref) {
  List<int> result = [];

  final sortedMyCardNumberList = [];
  sortedMyCardNumberList.addAll(ref.read(myCardNumberListProvider));
  sortedMyCardNumberList.sort();

  List<int> myCardLengthListPerPrefecture = List.generate(prefectureLength, (i)=> 0);
  List<int> myCardLengthListPerRegion = List.generate(regionLengthMap.length, (i)=> 0);

  int allMyCardLength = sortedMyCardNumberList.length;
  for (int i = 0; i < allMyCardLength; i++) {
    // カード番号の先頭2桁を抽出し、それをmyCardLengthListPerPrefectureのインデックスに利用してカード数を追加していく
    int extractedNumber = int.parse(sortedMyCardNumberList[i].substring(0, 2));
    if (extractedNumber != 0) {
      myCardLengthListPerPrefecture[extractedNumber - 1]++;
    } else {
      // イレギュラーのカード番号が含まれていた場合
      irregularCardMasterNumbers.forEach((key, value) {
        if (value == sortedMyCardNumberList[i]) {
          int index = addressList.indexOf(key);
          myCardLengthListPerPrefecture[index]++;
        }
      });
    }
  }

  List<int> regionLengthList = [];  // 各地方の都道府県数のリスト
  regionLengthMap.forEach((key, value) => regionLengthList.add(value));

  int regionLengthListIndex = 0;
  int border = regionLengthList[0];

  for (int i = 0; i < prefectureLength; i++) {
    myCardLengthListPerRegion[regionLengthListIndex] += myCardLengthListPerPrefecture[i];
    if (i + 1 == border && i < 46) {
      regionLengthListIndex++;
      border += regionLengthList[regionLengthListIndex];
    }
  }
  result.add(allMyCardLength);
  result.addAll(myCardLengthListPerRegion);
  result.addAll(myCardLengthListPerPrefecture);
  return result;
}