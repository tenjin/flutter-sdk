import 'package:flutter/material.dart';
import 'package:tenjin_analytics/tenjin_analytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                onPressed: () => TenjinAnalytics.connect(apiKey: '<API-KEY>'),
                child: Text('connect'),
              ),
              FlatButton(
                onPressed: () =>
                    TenjinAnalytics.sendCustomEvent(name: 'sendCustomEventThz'),
                child: Text('sendCustomEvent'),
              ),
              FlatButton(
                onPressed: () => TenjinAnalytics.sendCustomEventWithValue(
                  name: 'sendCustomEventWithValueThz',
                  value: '14',
                ),
                child: Text('sendCustomEventWithValue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
