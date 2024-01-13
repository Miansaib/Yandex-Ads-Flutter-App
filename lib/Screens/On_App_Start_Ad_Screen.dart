import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:yandex_test_ads_app/Screens/Banner_Screen.dart';
import 'package:yandex_test_ads_app/Screens/Native_Banner_Screen.dart';

class OnAdStartAdScreen extends StatefulWidget {
  const OnAdStartAdScreen({super.key});

  @override
  State<OnAdStartAdScreen> createState() => _OnAdStartAdScreenState();
}

class _OnAdStartAdScreenState extends State<OnAdStartAdScreen>
    with WidgetsBindingObserver {
  final _adUnitId = 'demo-appopenad-yandex';
  late var _adRequestConfiguration =
      AdRequestConfiguration(adUnitId: _adUnitId);
  AppOpenAd? _appOpenAd;
  late Future<AppOpenAdLoader> _appOpenAdLoader = _createAppOpenAdLoader();

  static var isAdShowing = false;
  static var isColdStartAdShown = false;

  Future<AppOpenAdLoader> _createAppOpenAdLoader() {
    return AppOpenAdLoader.create(
      onAdLoaded: (AppOpenAd appOpenAd) {
        // The ad was loaded successfully. Now you can handle it.
        _appOpenAd = appOpenAd;

        if (!isColdStartAdShown) {
          _showAdIfAvailable();
          isColdStartAdShown = true;
        }
      },
      onAdFailedToLoad: (error) {
        // The ad failed to load
        // Attempting to load a new ad from the OnAdFailedToLoad event is strongly discouraged.
      },
    );
  }

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _appOpenAdLoader = _createAppOpenAdLoader();
    _loadAppOpenAd();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _loadAppOpenAd() async {
    final adLoader = await _appOpenAdLoader;
    await adLoader.loadAd(adRequestConfiguration: _adRequestConfiguration);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _showAdIfAvailable();
    }
  }

  void _setAdEventListener({required AppOpenAd appOpenAd}) {
    appOpenAd.setAdEventListener(
        eventListener: AppOpenAdEventListener(onAdShown: () {
      // Called when an ad is shown.
      isAdShowing = true;
    }, onAdFailedToShow: (error) {
      // Called when an ad failed to show.

      // Clear resources after Ad dismissed.
      _clearAppOpenAd();
      // Now you can preload the next ad.
      _loadAppOpenAd();
    }, onAdDismissed: () {
      // Called when an ad is dismissed.
      isAdShowing = false;

      // Clear resources.
      _clearAppOpenAd();
      // Now you can preload the next ad.
      _loadAppOpenAd();
    }, onAdClicked: () {
      // Called when a click is recorded for an ad.
    }, onAdImpression: (data) {
      // Called when an impression is recorded for an ad.
    }));
  }

  Future<void> _showAdIfAvailable() async {
    var appOpenAd = _appOpenAd;
    if (appOpenAd != null && !isAdShowing) {
      _setAdEventListener(appOpenAd: appOpenAd);
      await appOpenAd.show();
      await appOpenAd.waitForDismiss();
    } else {
      _loadAppOpenAd();
    }
  }

  void _clearAppOpenAd() {
    _appOpenAd?.destroy();
    _appOpenAd = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Timer.run(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
        return NativeBannerScreen();
      }));
    });
    return Scaffold();
  }
}
