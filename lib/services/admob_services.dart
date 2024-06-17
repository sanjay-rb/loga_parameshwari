import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService with ChangeNotifier {
  BannerAd bannerAd;
  bool isLoaded = false;

  final adUnitId = dotenv.env['ANDROID_BANNER_AD_ID'];

  /// Loads a banner ad.
  void loadAd() {
    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('${ad.adUnitId} loaded.');
          isLoaded = true;
          notifyListeners();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
    notifyListeners();
  }
}
