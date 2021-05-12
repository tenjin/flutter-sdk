import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tenjin_sdk/tenjin_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    TenjinSDK.instance.init(apiKey: '<API-KEY>');
    TenjinSDK.instance.optIn();
    TenjinSDK.instance.registerAppForAdNetworkAttribution();
    TenjinSDK.instance.setRewardCallback = (bool clickedTenjinLink,
        bool isFirstSession, Map<String, String> data) {
      if (isFirstSession) {
        if (clickedTenjinLink) {
          if (data.containsKey(TenjinSDK.DEEPLINK_URL)) {
            // use the deferred_deeplink_url to direct the user to a specific part of your app
          }
        }
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tenjin SDK')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => TenjinSDK.instance.connect(),
                child: Text('connect'),
              ),
              TextButton(
                onPressed: () =>
                    TenjinSDK.instance.eventWithName('swipe_right'),
                child: Text('eventWithName'),
              ),
              TextButton(
                onPressed: () =>
                    TenjinSDK.instance.eventWithNameAndValue('item', 100),
                child: Text('eventWithNameAndValue'),
              ),
              if (Platform.isIOS)
                TextButton(
                  onPressed: () {
                    TenjinSDK.instance.requestTrackingAuthorization();
                  },
                  child: Text('Request Tracking Authorization'),
                ),
              TextButton(
                onPressed: () {
                  TenjinSDK.instance.transaction(
                    productId: 'productId',
                    currencyCode: 'USD',
                    quantity: 1,
                    unitPrice: 3.80,
                    iosReceipt: 'iosReceipt',
                    iosTransactionId: 'transactionId',
                    androidDataSignature: 'androidDataSignature',
                    androidPurchaseData: 'androidPurchaseData',
                  );
                },
                child: Text('transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
