import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  bool _initialized = false;

  // Test Ad Unit IDs
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9009761598954280/8051390182';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9009761598954280/3002620786';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      log('Google Mobile Ads SDK initialized successfully.');
    } catch (e) {
      log('Error initializing Google Mobile Ads SDK: $e');
    }
  }

  // Helper method to load a banner ad
  BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    required VoidCallback onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('Banner ad loaded.');
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          log('Banner ad failed to load: $error');
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );
  }

  // Pre-load and show an Interstitial Ad
  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('Interstitial ad loaded successfully.');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              log('Interstitial ad dismissed.');
              ad.dispose();
              onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log('Interstitial ad failed to show: $error');
              ad.dispose();
              onAdDismissed();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          log('Interstitial ad failed to load: $error');
          // If ad fails to load, proceed immediately with the callback so the user flow is not blocked
          onAdDismissed();
        },
      ),
    );
  }
}
