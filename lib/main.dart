import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yandex_test_ads_app/Constants/Size.dart';
import 'package:yandex_test_ads_app/Screens/Banner_Screen.dart';
import 'package:yandex_test_ads_app/Screens/Interstitial_Screen.dart';
import 'package:yandex_test_ads_app/Screens/Native_Banner_Screen.dart';
import 'package:yandex_test_ads_app/Screens/On_App_Start_Ad_Screen.dart';
import 'package:yandex_test_ads_app/Screens/Rewarded_Screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Timer.run(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
        return OnAdStartAdScreen();
      }));
    });
    return const Scaffold();
  }
}
