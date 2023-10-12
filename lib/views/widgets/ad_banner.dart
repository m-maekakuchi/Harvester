import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../commons/ad_banner_id.dart';

BannerAd bannerAd = BannerAd(
  adUnitId: getAdBannerUnitId(),
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);