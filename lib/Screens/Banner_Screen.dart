import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:yandex_test_ads_app/Constants/Size.dart';

class BannerHome extends StatefulWidget {
  const BannerHome({super.key});

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  late BannerAd banner;
  var isBannerAlreadyCreated = false;

  _loadAd() async {
    banner = _createBanner();
    setState(() {
      isBannerAlreadyCreated = true;
    });
    // If banner was already created you can just call:
    // banner.loadAd(adRequest: const AdRequest());
  }

  _createBanner() {
    return BannerAd(
        adUnitId: 'R-M-4830574-1', // or 'demo-banner-yandex'
        adSize: BannerAdSize.inline(width: size.width.toInt(), maxHeight: 60),
        adRequest: const AdRequest(),
        onAdLoaded: () {
          // The ad was loaded successfully. Now it will be shown.
        },
        onAdFailedToLoad: (error) {
          // Ad failed to load with AdRequestError.
          // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
        },
        onAdClicked: () {
          // Called when a click is recorded for an ad.
        },
        onLeftApplication: () {
          // Called when user is about to leave application (e.g., to go to the browser), as a result of clicking on the ad.
        },
        onReturnedToApplication: () {
          // Called when user returned to application after click.
        },
        onImpression: (impressionData) {
          // Called when an impression is recorded for an ad.
        });
  }

  @override
  initState() {
    super.initState();
    MobileAds.initialize();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: isBannerAlreadyCreated ? AdWidget(bannerAd: banner) : null,
      ),
    );
  }
}
