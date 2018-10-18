import 'package:converter_pro/ConversionManager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String app_id= "ca-app-pub-8125901756552853~1510088371";

MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
  keywords: <String>['math', 'physics',"numbers", "measure"],
  contentUrl: 'https://flutter.io',
  birthday: new DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = new BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-8125901756552853/6183830557",
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = new InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);

void main() => runApp(new SandboxApp());


class SandboxApp extends StatefulWidget {
  @override
  _SandboxAppState createState() => _SandboxAppState();
}

class _SandboxAppState extends State<SandboxApp> {

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: app_id);

  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      title: 'FCM - Calculator',
      home: ConversionManager(),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.indigo,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      builder: (BuildContext context, Widget child){

        myBanner
        // typically this happens well before the ad is shown
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
          );

        var mediaQuery=MediaQuery.of(context);
        double paddingBottom=50.0;
        if(mediaQuery.orientation==Orientation.landscape)
          paddingBottom=0.0;


        return Padding(
          child: child,
          padding: EdgeInsets.only(bottom: paddingBottom),
        );
      },
    );
  }
}