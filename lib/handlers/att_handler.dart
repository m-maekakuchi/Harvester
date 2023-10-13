import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';

class ATTHelper {
  Future<void> attCheck() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    //ATTが設定されていない場合実行
    if (status == TrackingStatus.notDetermined) {
      debugPrint('ATT未設定');
      await Future.delayed(const Duration(milliseconds: 200));
      //ダイアログ表示
      await AppTrackingTransparency.requestTrackingAuthorization();
    } else {
      // Androidなら戻り地がTrackingStatus.notSupported
      // iOSで設定済みの場合
      if (status != TrackingStatus.notSupported) debugPrint('ATT設定済');
    }
  }
}