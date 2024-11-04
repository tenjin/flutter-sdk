import 'dart:io';

import 'package:flutter/services.dart';

class TenjinSDK {
  TenjinSDK._();

  static TenjinSDK instance = TenjinSDK._();

  final MethodChannel _channel = const MethodChannel('tenjin_plugin');

  Future<void> init({required String apiKey}) async {
    await _channel.invokeMethod('init', {'apiKey': apiKey});
  }

  Future<void> connect() => _channel.invokeMethod('connect');

  Future<void> optIn() => _channel.invokeMethod('optIn');

  Future<void> optOut() => _channel.invokeMethod('optOut');

  Future<void> optInParams(List<String> params) =>
      _channel.invokeMethod('optInParams', {'params': params});

  Future<void> optOutParams(List<String> params) =>
      _channel.invokeMethod('optOutParams', {'params': params});

  Future<void> optInOutUsingCMP() => _channel.invokeMethod('optInOutUsingCMP');

  Future<void> optOutGoogleDMA() => _channel.invokeMethod('optOutGoogleDMA');

  Future<void> optInGoogleDMA() => _channel.invokeMethod('optInGoogleDMA');

  Future<void> eventWithName(String name) =>
      _channel.invokeMethod('eventWithName', {'name': name});

  Future<void> eventWithNameAndValue(String name, int value) async {
    await _channel.invokeMethod('eventWithNameAndValue', {
      'name': name,
      'value': value,
    });
  }

  Future<bool> requestTrackingAuthorization() async {
    final result = await _channel.invokeMethod('requestTrackingAuthorization');
    return Future.value(result as bool);
  }

  Future<void> registerAppForAdNetworkAttribution() =>
      _channel.invokeMethod('registerAppForAdNetworkAttribution');

  Future<void> updatePostbackConversionValue(int conversionValue) async {
    await  _channel.invokeMethod('updatePostbackConversionValue', {
      'conversionValue': conversionValue,
    });
  }

  Future<void> updatePostbackConversionValueCoarseValue(int conversionValue, String coarseValue) async {
    await  _channel.invokeMethod('updatePostbackConversionValueCoarseValue', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
    });
  }

  Future<void> updatePostbackConversionValueCoarseValueLockWindow(int conversionValue, String coarseValue, bool lockWindow) async {
    await  _channel.invokeMethod('updatePostbackConversionValueCoarseValueLockWindow', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
      'lockWindow': lockWindow,
    });
  }

  Future<void> transaction(String productName, String currencyCode, double quantity, double unitPrice) async {
    await _channel.invokeMethod('transaction', {
      'productName': productName,
      'currencyCode': currencyCode,
      'quantity': quantity,
      'unitPrice': unitPrice,
    });
  }

  Future<void> transactionWithReceipt({
    required String productId,
    required String currencyCode,
    required double unitPrice,
    required int quantity,
    String? androidPurchaseData,
    String? androidDataSignature,
    String? iosReceipt,
    String? iosTransactionId,
  }) async {
    bool isValidIOS =
        Platform.isIOS && iosReceipt != null && iosTransactionId != null;
    bool isValidAndroid = Platform.isAndroid &&
        androidPurchaseData != null &&
        androidDataSignature != null;
    if (isValidIOS || isValidAndroid) {
      await _channel.invokeMethod('transactionWithReceipt', {
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
      print('TenjinSDK.instance transaction is missing data');
    }
  }

  Future<void> appendAppSubversion(int value) =>
      _channel.invokeMethod('appendAppSubversion', {'value': value});

  Future<Map<String, dynamic>?> getAttributionInfo() async {
    try {
      final dynamic response = await _channel.invokeMethod('getAttributionInfo');
      if (response is Map) {
        final Map<String, dynamic> stringKeyedMap = response.map((key, value) {
          return MapEntry(key.toString(), value);
        });
        return stringKeyedMap;
      }
      throw Exception("Received invalid type for attribution info.");
    } on PlatformException catch (e) {
      print("Failed to get attribution info: '${e.message}'.");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }

  Future<void> setCustomerUserId(String userId) async {
    await _channel.invokeMethod('setCustomerUserId', {'userId': userId});
  }

  Future<String?> getCustomerUserId() async {
    try {
      final String? userId = await _channel.invokeMethod('getCustomerUserId');
      return userId;
    } on PlatformException catch (e) {
      print("Failed to get user id: '${e.message}'.");
      return null;
    }
  }

  Future<void> setCacheEventSetting(bool setting) async {
    await _channel.invokeMethod('setCacheEventSetting', {'setting': setting});
  }

  Future<String?> getAnalyticsInstallationId() async {
    try {
      final String? installationId = await _channel.invokeMethod('getAnalyticsInstallationId');
      return installationId;
    } on PlatformException catch (e) {
      print("Failed to get analytics installation id: '${e.message}'.");
      return null;
    }
  }

  Future<void> setGoogleDMAParameters(bool adPersonalization, bool adUserData) async {
    await _channel.invokeMethod('setGoogleDMAParameters', {
      'adPersonalization': adPersonalization,
      'adUserData': adUserData,
    });
  }

  Future<void> eventAdImpressionAdMob(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionAdMob', json);
  }

  Future<void> eventAdImpressionAppLovin(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionAppLovin', json);
  }

  Future<void> eventAdImpressionHyperBid(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionHyperBid', json);
  }

  Future<void> eventAdImpressionIronSource(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionIronSource', json);
  }
  
  Future<void> eventAdImpressionTopOn(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionTopOn', json);
  }

  Future<void> eventAdImpressionTradPlus(Map<String, dynamic> json) async {
    await _channel.invokeMethod('eventAdImpressionTradPlus', json);
  }

  Future<void> eventAdImpressionTradPlusAdInfo(Map<String, dynamic> json) async {
    Map<String, dynamic> transformedJson = {};
    
    if (Platform.isIOS) {
      transformedJson['revenue'] = json['ecpm'];
      transformedJson['ad_unit_id'] = json['adunit_id'];
      transformedJson['network_name'] = json['adNetworkName'];
      transformedJson['creative_id'] = json['creativeIdentifier'];
      transformedJson['revenue_precision'] = json['ecpm_precision'];
      transformedJson['format'] = json['placement_ad_type'];
      transformedJson['country'] = json['country_code'];
      transformedJson['ab_test'] = json['bucket_id'];
      transformedJson['segment'] = json['segment_id'];
      transformedJson['placement'] = json['adsource_placement_id'];
    } else if (Platform.isAndroid) {
      transformedJson['ad_unit_id'] = json['tpAdUnitId'];
      transformedJson['network_name'] = json['adSourceName'];
      transformedJson['revenue'] = json['ecpm'];
      transformedJson['revenue_precision'] = json['ecpmPrecision'];
      transformedJson['placement'] = json['adSourcePlacementId'];
      transformedJson['ab_test'] = json['bucketId'];
      transformedJson['segment'] = json['segmentId'];
      transformedJson['country'] = json['isoCode'];
      transformedJson['format'] = json['format'];
    }
    
    await _channel.invokeMethod('eventAdImpressionTradPlus', transformedJson);
  }
}
