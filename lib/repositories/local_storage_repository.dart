import 'package:hive_flutter/adapters.dart';

import '../models/user_info_model.dart';

class LocalStorageRepository {

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<UserInfoModel?> fetchUserInfo() async {
    try {
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
    } catch (e, stackTrace) {
      print("エラー発生：$e");
      print(stackTrace);
      return null;
    }
  }

  Future<void> putUserInfo(UserInfoModel userInfoModel) async {
    try {
      var box = await Hive.openBox('userBox');
      await box.put('userInfo', {
        "name": userInfoModel.name,
        "addressIndex": userInfoModel.addressIndex,
        "birthday": userInfoModel.birthday,
      });
    } catch (e, stackTrace) {
      print("エラー発生：$e");
      print(stackTrace);
    }
  }

  Future<List<Map<String, dynamic>>?> fetchMyCardIdAndFavorites() async {
    try {
      var box = await Hive.openBox('cardBox');
      final myCardInfoList = box.get('myCardNumber');
      List<Map<String, dynamic>> result;
      if (myCardInfoList != null) {
        result = [];
        for (Map<dynamic, dynamic> myCardInfo in myCardInfoList) {
          Map<String, dynamic> myCardInfoMap = {
            "id": myCardInfo["id"],
            "favorite": myCardInfo["favorite"],
          };
          result.add(myCardInfoMap);
        }
        return result;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      print("エラー発生：$e");
      print(stackTrace);
      return null;
    }
  }

  Future<void> putMyCardIdAndFavorites(List<Map<String, dynamic>> cardNumberList) async {
    try {
      var box = await Hive.openBox('cardBox');
      await box.put('myCardNumber', cardNumberList);
    } catch (e, stackTrace) {
      print("エラー発生：$e");
      print(stackTrace);
    }
  }

}