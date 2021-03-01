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
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () => TenjinSDK.instance.connect(),
                child: Text('connect'),
              ),
              FlatButton(
                onPressed: () =>
                    TenjinSDK.instance.eventWithName('swipe_right'),
                child: Text('eventWithName'),
              ),
              FlatButton(
                onPressed: () =>
                    TenjinSDK.instance.eventWithNameAndValue('item', 100),
                child: Text('eventWithNameAndValue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
