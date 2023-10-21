import 'package:flutter/material.dart';
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
    } catch (e) {
      debugPrint("*****ローカルのユーザー情報の登録に失敗しました*****");
      rethrow;
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      var box = await Hive.openBox('userBox');
      box.delete("userInfo");
    } catch (e) {
      debugPrint("*****ローカルのユーザー情報の削除に失敗しました*****");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchMyCardIdAndFavorites() async {
    try {
      var box = await Hive.openBox('cardBox');
      final myCardInfoList = box.get('myCardNumber');
      List<Map<String, dynamic>>? result;
      if (myCardInfoList != null) {
        result = [];
        for (Map<dynamic, dynamic> myCardInfo in myCardInfoList) {
          Map<String, dynamic> myCardInfoMap = {
            "id": myCardInfo["id"],
            "favorite": myCardInfo["favorite"],
          };
          result.add(myCardInfoMap);
        }
      }
      return result;
    } catch (e) {
      debugPrint("*****ローカルに保存済のマイカードの番号とお気に入り登録有無の取得に失敗しました*****");
      rethrow;
    }
  }

  Future<void> putMyCardIdAndFavorites(List<Map<String, dynamic>> cardNumberList) async {
    try {
      var box = await Hive.openBox('cardBox');
      await box.put('myCardNumber', cardNumberList);
    } catch (e) {
      debugPrint("*****ローカルのマイカード情報の登録に失敗しました*****");
      rethrow;
    }
  }

  Future<void> deleteMyCardIdAndFavorites() async {
    try {
      var box = await Hive.openBox('cardBox');
      box.delete("myCardNumber");
    } catch (e) {
      debugPrint("*****ローカルのマイカード情報の削除に失敗しました*****");
      rethrow;
    }
  }

}