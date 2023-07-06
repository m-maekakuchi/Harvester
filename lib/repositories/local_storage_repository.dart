import 'package:hive_flutter/adapters.dart';

import '../models/user_info_model.dart';

class LocalStorageRepository {

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<UserInfoModel?> fetchUserInfo() async {
    var box = await Hive.openBox('userBox');
    var userInfo = box.get('userInfo');
    if (userInfo == null) {
      return null;
    } else {
      return UserInfoModel(
        name: userInfo['name'],
        addressIndex: userInfo['addressIndex'],
        birthday: userInfo['birthday'],
      );
    }
  }

  Future<void> putUserInfo(UserInfoModel userInfoModel) async {
    var box = await Hive.openBox('userBox');
    await box.put('userInfo', {
      "name": userInfoModel.name,
      "addressIndex": userInfoModel.addressIndex,
      "birthday": userInfoModel.birthday,
    });
  }

  Future<List<String>?> fetchMyCardNumber() async {
    var box = await Hive.openBox('cardBox');
    var myCardNumber = box.get('myCardNumber');
    return myCardNumber;
  }

  Future<void> putMyCardNumber(List<String> cardNumberList) async {
    var box = await Hive.openBox('cardBox');
    await box.put('myCardNumber', cardNumberList);
  }

  // Future<List<CardMasterModel>?> fetchCardMasterList() async {
  //   var box = await Hive.openBox('cardMasterBox');
  //   var cardMasterMapList = box.get('cardMasterList');
  //   if (cardMasterMapList == null) {
  //     return null;
  //   } else {
  //     List<CardMasterModel> cardMasterModelList = [];
  //     for (Map<String, dynamic> item in cardMasterMapList) {
  //       cardMasterModelList.add(CardMasterModel(
  //         serialNumber: item['serial_number'],
  //         prefecture: item['prefecture'],
  //         city: item['city'],
  //         version: item['version'],
  //         issueDay: item['issue_day'],
  //         comment: item['comment'],
  //         stockLink: item['stock_link'],
  //         distributeLocations: item['distribute_locations'],
  //         distributeAddresses: item['distribute_addresses'],
  //         locationLinks: item['location_links'],
  //       ));
  //     }
  //     return cardMasterModelList;
  //   }
  // }
  //
  // Future<void> putCardMasterList(List<CardMasterModel> list) async {
  //   var box = await Hive.openBox('cardMasterBox');
  //   List cardMasterMapList = [];
  //   for (CardMasterModel item in list) {
  //     cardMasterMapList.add(item.toFirestore());
  //   }
  //   await box.put('cardMasterList', cardMasterMapList);
  // }
  //
  // Future<Map<String, List<String>>?> fetchCardMasterOptionMap() async {
  //   var box = await Hive.openBox('cardMasterBox');
  //   var cardMasterOptionMap = box.get('cardMasterOptionMap');
  //   if (cardMasterOptionMap == null) {
  //     return null;
  //   } else {
  //     Map<String, List<String>> list = {};
  //     cardMasterOptionMap.forEach((key, value) {
  //       list[key] = value;
  //     });
  //     return list;
  //   }
  // }
  //
  // Future<void> putCardMasterOptionMap(Map<String, List<String>> cardNumberAndCityMap) async {
  //   var box = await Hive.openBox('cardMasterBox');
  //   await box.put('cardMasterOptionMap', cardNumberAndCityMap);
  // }

}