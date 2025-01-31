import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kDebugMode) {
      debugPrint("Now in debug mode.");
      if (Platform.isAndroid) {
        return "${dotenv.env["TEST_BANNER_AD_ID_ANDROID"]}";
      } else if (Platform.isIOS) {
        return "${dotenv.env["TEST_BANNER_AD_ID_IOS"]}";
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {
      if (Platform.isAndroid) {
        return "${dotenv.env["BANNER_AD_ID_ANDROID"]}";
      } else if (Platform.isIOS) {
        return "${dotenv.env["BANNER_AD_ID_IOS"]}";
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      debugPrint("Now in debug mode.");
      if (Platform.isAndroid) {
        return "${dotenv.env["TEST_INTERSTITIAL_AD_ID_ANDROID"]}";
      } else if (Platform.isIOS) {
        return "${dotenv.env["TEST_INTERSTITIAL_AD_ID_IOS"]}";
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {
      if (Platform.isAndroid) {
        return "${dotenv.env["INTERSTITIAL_AD_ID_ANDROID"]}";
      } else if (Platform.isIOS) {
        return "${dotenv.env["INTERSTITIAL_AD_ID_IOS"]}";
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }

  static final BannerAdListener bannderAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint("Ad fail to load: $error");
    },
    onAdOpened: (ad) => debugPrint("Ad opened"),
    onAdClosed: (ad) => debugPrint("Ad closed"),
  );
}
