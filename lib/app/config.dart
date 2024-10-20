import 'dart:ui';


class Config {

  static const String packageNameAndroid = "com.mediakliq.betavs";
  static const String packageNameiOS = "com.mediakliq.betavs";
  static const String iosAppStoreId = "";
  static final String appName = "Betavs";
  static final String appVersion = "1.0.0";
  static final String companyName = "Betavs, inc";
  static final String appOrCompanyUrl = "https://bettavs.com";
  static final String initialCountry = 'US'; // United States

  static final String serverUrl = "https://parseapi.back4app.com";
  static final String liveQueryUrl = "wss://bettavs.b4a.io";
  static final String appId = "Lhg2sc55jXKqZfIel2pKuMJw2dkb3Ccj9vQdinZd";
  static final String clientKey = "PlNgKsvGHCea99uvIskEAqGg4W4HYPFUMhwRfgNi";

  //OneSignal
  static final String oneSignalAppId = "afb1e914----";

  // Firebase Cloud Messaging
  static final String pushGcm = "523118236574";
  static final String webPushCertificate = "BM7VNLnLd27iRQpwYJmBKKJmFCB6KH8kdm7vtRWuLWaoqLawQ-h3HabhgNGktV5ep54uQl1o_SY1L1hb57Ln-2o";

  // User support objectId
  static final String supportId = "";

  // Play Store and App Store public keys
  static final String publicGoogleSdkKey = "";
  static final String publicIosSdkKey = "";

  // Languages
  static String defaultLanguage = "en"; // English is default language.
  static List<Locale> languages = [
    Locale(defaultLanguage),
    //Locale('pt'),
    //Locale('fr')
  ];

  // Android Admob ad
  static const String admobAndroidOpenAppAd = "ca-app-pub-5449787836067264/2006216854";
  static const String admobAndroidHomeBannerAd = "ca-app-pub-5449787836067264/8348549332";
  static const String admobAndroidFeedNativeAd = "ca-app-pub-5449787836067264/8711226009";
  static const String admobAndroidChatListBannerAd = "ca-app-pub-5449787836067264/8711226009";
  static const String admobAndroidLiveBannerAd = "ca-app-pub-5449787836067264/2006216854";
  static const String admobAndroidFeedBannerAd = "ca-app-pub-5449787836067264/8711226009";

  // iOS Admob ad
  static const String admobIOSOpenAppAd = "";
  static const String admobIOSHomeBannerAd = "";
  static const String admobIOSFeedNativeAd = "";
  static const String admobIOSChatListBannerAd = "";
  static const String admobIOSLiveBannerAd = "";
  static const String admobIOSFeedBannerAd = "";

  // Web links for help, privacy policy and terms of use.
  static final String helpCenterUrl = "https://trace-34749.web.app/terms/";
  static final String privacyPolicyUrl = "https://trace-34749.web.app/pivacy/";
  static final String termsOfUseUrl = "https://trace-34749.web.app/terms/";
  static final String termsOfUseInAppUrl = "https://trace-34749.web.app/terms/";
  static final String dataSafetyUrl = "https://ladylivea.net/help.hmtl";
  static final String openSourceUrl = "https://www.ladylivea.net/third-party-license.html";
  static final String instructionsUrl = "https://ladylivea.net/instructions.hmtl";
  static final String cashOutUrl = "https://ladylivea.net/cashout.hmtl";
  static final String supportUrl = "https://www.ladylivea.net/support";
  static final String liveAgreementUrl = "https://trace-34749.web.app/live/";
  static final String userAgreementUrl = "https://trace-34749.web.app/user/";

  // Google Play and Apple Pay In-app Purchases IDs
  static final String credit100 = "betavs.100.credits";
  static final String credit200 = "betavs.200.credits";
  static final String credit500 = "betavs.500.credits";
  static final String credit1000 = "betavs.1000.credits";
  static final String credit2100 = "betavs.2100.credits";
  static final String credit5250 = "betavs.5250.credits";
  static final String credit10500 = "betavs.10500.credits";
}