import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class InterstitialScreen extends StatefulWidget {
  const InterstitialScreen({super.key});

  @override
  State<InterstitialScreen> createState() => _InterstitialScreenState();
}

class _InterstitialScreenState extends State<InterstitialScreen> {
  late final Future<InterstitialAdLoader> _adLoader;
  InterstitialAd? _ad;

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _adLoader = _createInterstitialAdLoader();
    _loadInterstitialAd();
  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _ad = interstitialAd;
      },
      onAdFailedToLoad: (error) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: AdRequestConfiguration(
            adUnitId:
                'R-M-4830574-2')); // For debugging, you can use 'demo-interstitial-yandex'
  }

  _showAd() async {
    _ad?.setAdEventListener(
        eventListener: InterstitialAdEventListener(
      onAdShown: () {
        // Called when an ad is shown.
      },
      onAdFailedToShow: (error) {
        // Called when an InterstitialAd failed to show.
        // Destroy the ad so you don't show the ad a second time.
        _ad?.destroy();
        _ad = null;

        // Now you can preload the next interstitial ad.
        _loadInterstitialAd();
      },
      onAdClicked: () {
        // Called when a click is recorded for an ad.
      },
      onAdDismissed: () {
        // Called when ad is dismissed.
        // Destroy the ad so you don't show the ad a second time.
        _ad?.destroy();
        _ad = null;

        // Now you can preload the next interstitial ad.
        _loadInterstitialAd();
      },
      onAdImpression: (impressionData) {
        // Called when an impression is recorded for an ad.
      },
    ));
    await _ad?.show();
    await _ad?.waitForDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _showAd();
            },
            child: Text('Show Ad')),
      ),
    );
  }
}
