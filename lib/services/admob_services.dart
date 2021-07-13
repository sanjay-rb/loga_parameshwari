import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This services helps to conect and create the ads with AdMob....
///
/// All given Ad ID's are test ads....
///
/// Please feel free to change the ID's with your App ID's....
///
/// Flutter 1.22.0 or higher
///
/// Android :-
///  - Android Studio 3.2 or higher,
///  - Target Android API level 19 or higher,
///  - Set compileSdkVersion to 28 or higher,
///  - Android Gradle Plugin 4.1 or higher (this is the version supported by Flutter out of the box),
///
/// Ios :-
///  - Latest version of Xcode with enabled command-line tools.,
///  - Recommended: Create an AdMob account and register an Android and/or iOS app,
///
/// Manifest:-
/// ```
/// <manifest>
///     <application>
///         <meta-data
///            android:name="com.google.android.gms.ads.APPLICATION_ID"
///             android:value="ca-app-pub-3940256099942544~3347511713"/> // Sample value
///     </application>
/// </manifest>
///```
class AdmobServices {
  static String get bannerAdUnitId => "ca-app-pub-3940256099942544/6300978111";
  static String get interstitialAdUnitId =>
      "ca-app-pub-3940256099942544/1033173712";

  /// Please call the init() on main or splash screen....
  static init() async {
    if (MobileAds.instance == null) {
      await MobileAds.instance.initialize();
    }
  }

  /// This function just create the banner ad for the development....
  ///
  /// Please use below code to show the ad where ever you want....
  ///
  /// ```
  /// AdWidget(
  ///   ad: AdmobServices.createBannerAd()..load(),
  ///   key: UniqueKey(),
  /// );
  /// ```
  static BannerAd createBannerAd({AdSize adSize}) {
    BannerAd ad = BannerAd(
      adUnitId: bannerAdUnitId,
      request: AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) => print("$ad Loaded...."),
        onAdFailedToLoad: (ad, error) {
          print("$ad Failed to load with error $error");
          ad.dispose();
        },
        onAdOpened: (ad) => print("$ad Opened...."),
        onAdClosed: (ad) => print("$ad Closed...."),
      ),
    );
    return ad;
  }
}
