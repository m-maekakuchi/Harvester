import 'package:hive_flutter/adapters.dart';

import '../models/user_info_model.dart';

class LocalStorageRepository {

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<UserInfoModel> fetchUserInfo() async {
    var box = await Hive.openBox('userBox');
    var userInfo = box.get('userInfo');
    return UserInfoModel(
      name: userInfo['name'],
      addressIndex: userInfo['addressIndex'],
      birthday: userInfo['birthday'],
    );
  }

  Future<void> putUserInfo(UserInfoModel userInfoModel) async {
    var box = await Hive.openBox('userBox');
    await box.put('userInfo', {
      "name": userInfoModel.name,
      "addressIndex": userInfoModel.addressIndex,
      "birthday": userInfoModel.birthday,
    });
  }

}