import 'dart:io';

String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android
    bannerUnitId = "ca-app-pub-3940256099942544/6300978111"; // Androidのデモ用バナー広告ID
    // bannerUnitId = "ca-app-pub-4486887160753150/1961074697"; // Androidのバナー広告ID
  } else if (Platform.isIOS) {
    // iOS
    bannerUnitId = "ca-app-pub-3940256099942544/2934735716"; // iOSのデモ用バナー広告ID
    // bannerUnitId = "ca-app-pub-4486887160753150/5144010929"; // iOSの広告ID
  }
  return bannerUnitId;
}