import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class RewardedAdsScreen extends StatefulWidget {
  const RewardedAdsScreen({super.key});

  @override
  State<RewardedAdsScreen> createState() => _RewardedAdsScreenState();
}

class _RewardedAdsScreenState extends State<RewardedAdsScreen> {
  late final Future<RewardedAdLoader> _adLoader;
  RewardedAd? _ad;

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _adLoader = _createRewardedAdLoader();
    _loadRewardedAd();
  }

  Future<RewardedAdLoader> _createRewardedAdLoader() {
    return RewardedAdLoader.create(
      onAdLoaded: (RewardedAd rewardedAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _ad = rewardedAd;
      },
      onAdFailedToLoad: (error) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
    );
  }

  Future<void> _loadRewardedAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: AdRequestConfiguration(
            adUnitId:
                'demo-rewarded-yandex')); // For debugging, you can use 'demo-rewarded-yandex'
  }

  _showAd() async {
    _ad?.setAdEventListener(
        eventListener: RewardedAdEventListener(onAdShown: () {
      // Called when an ad is shown.
    }, onAdFailedToShow: (error) {
      // Called when an ad failed to show.
      // Destroy the ad so you don't show the ad a second time.
      _ad?.destroy();
      _ad = null;

      // Now you can preload the next ad.
      _loadRewardedAd();
    }, onAdClicked: () {
      // Called when a click is recorded for an ad.
    }, onAdDismissed: () {
      // Called when ad is dismissed.
      // Destroy the ad so you don't show the ad a second time.
      _ad?.destroy();
      _ad = null;

      // Now you can preload the next ad.
      _loadRewardedAd();
    }, onAdImpression: (impressionData) {
      // Called when an impression is recorded for an ad.
    }, onRewarded: (Reward reward) {
      // Called when the user can be rewarded.
    }));

    await _ad?.show();
    final reward = await _ad?.waitForDismiss();
    if (reward != null) {
      print('got ${reward.amount} of ${reward.type}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _showAd();
            },
            child: Text('Show Rewarded Ad')),
      ),
    );
  }
}
