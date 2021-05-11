import 'dart:io';

import 'package:flutter/services.dart';

class TenjinSDK {
  TenjinSDK._();

  static TenjinSDK instance = TenjinSDK._();

  Function(bool clickedTenjinLink, bool isFirstSession,
      Map<String, String> data)? _onSucessDeeplink;

  final MethodChannel _channel = const MethodChannel('tenjin_sdk');

  Future init({required String apiKey}) async {
    _channel.invokeMethod('init', {'apiKey': apiKey});
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSucessDeeplink') {
        _onSucessDeeplink?.call(
          call.arguments['clickedTenjinLink'] as bool,
          call.arguments['isFirstSession'] as bool,
          call.arguments['data'] as Map<String, String>,
        );
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
      _channel.invokeMethod('eventWithName', {'name': name});

  void eventWithNameAndValue(String name, int value) {
    _channel.invokeMethod('eventWithNameAndValue', {
      'name': name,
      'value': value,
    });
  }

  Future<bool> requestTrackingAuthorization() async =>
      await _channel.invokeMethod('requestTrackingAuthorization')
          as Future<bool>;

  Future<void> registerAppForAdNetworkAttribution() =>
      _channel.invokeMethod('registerAppForAdNetworkAttribution');

  void updateConversionValue(int value) {
    _channel.invokeMethod('updateConversionValue', {
      'value': value,
    });
  }

  void transaction({
    required String productId,
    required String currencyCode,
    required double unitPrice,
    required int quantity,
    String? androidPurchaseData,
    String? androidDataSignature,
    String? iosReceipt,
    String? iosTransactionId,
  }) {
    bool isValidIOS =
        Platform.isIOS && iosReceipt != null && iosTransactionId != null;
    bool isValidAndroiod = Platform.isAndroid &&
        androidPurchaseData != null &&
        androidDataSignature != null;
    if (isValidIOS || isValidAndroiod) {
      _channel.invokeMethod('transaction', {
        'productId': productId,
        'purchaseData': androidPurchaseData,
        'dataSignature': androidDataSignature,
        'currencyCode': currencyCode,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'receipt': iosReceipt,
        'transactionId': iosTransactionId,
      });
    } else {
      print('TenjinSDK.instancetransaction is missing data');
    }
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
