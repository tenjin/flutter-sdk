import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TenjinSDK {
  TenjinSDK._();

  static TenjinSDK instance = TenjinSDK._();

  Function(
          bool clickedTenjinLink, bool isFirstSession, Map<String, String> data)
      _onSucessDeeplink;

  final MethodChannel _channel = const MethodChannel('tenjin_sdk');

  void init({@required String apiKey}) {
    _channel.invokeMethod('init', {'apiKey': apiKey});

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSucessDeeplink') {
        if (_onSucessDeeplink != null) {
          _onSucessDeeplink(
            call.arguments['clickedTenjinLink'] as bool,
            call.arguments['isFirstSession'] as bool,
            call.arguments['data'] as Map<String, String>,
          );
        }
      }
      return Future.value();
    });
  }

  void connect() => _channel.invokeMethod('connect');

  void optIn() => _channel.invokeMethod('optIn');

  void optOut() => _channel.invokeMethod('optOut');

  void optInParams(List<String> params) =>
      _channel.invokeMethod('optInParams', {'params': params});

  void optOutParams(List<String> params) =>
      _channel.invokeMethod('optOutParams', {'params': params});

  void eventWithName(String name) =>
      _channel.invokeMethod('sendCustomEvent', {'name': name});

  void eventWithNameAndValue(String name, int value) {
    _channel.invokeMethod('sendCustomEventWithValue', {
      'name': name,
      'value': value,
    });
  }

  void transaction({
    @required String productId,
    @required String purchaseData,
    @required String dataSignature,
    @required String currencyCode,
    @required double unitPrice,
    @required int quantity,
  }) {
    _channel.invokeMethod('transaction', {
      'productId': productId,
      'purchaseData': purchaseData,
      'dataSignature': dataSignature,
      'currencyCode': currencyCode,
      'unitPrice': unitPrice,
      'quantity': quantity,
    });
  }

  void appendAppSubversion(int value) =>
      _channel.invokeMethod('appendAppSubversion', {'value': value});

  set setRewardCallback(
    Function(bool clickedTenjinLink, bool isFirstSession,
            Map<String, String> data)
        callback,
  ) =>
      _onSucessDeeplink = callback;
      
  static final String DEEPLINK_URL = "deferred_deeplink_url";
}
