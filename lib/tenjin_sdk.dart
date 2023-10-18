import 'dart:io';

import 'package:flutter/services.dart';

class TenjinSDK {
  TenjinSDK._();

  static TenjinSDK instance = TenjinSDK._();

  final MethodChannel _channel = const MethodChannel('tenjin_plugin');

  void init({required String apiKey}) async {
    _channel.invokeMethod('init', {'apiKey': apiKey});
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

  Future<bool> requestTrackingAuthorization() async {
      final result = await _channel.invokeMethod('requestTrackingAuthorization');
      return Future.value(result as bool);
  }

  void registerAppForAdNetworkAttribution() =>
      _channel.invokeMethod('registerAppForAdNetworkAttribution');

  void updatePostbackConversionValue(int conversionValue) {
    _channel.invokeMethod('updatePostbackConversionValue', {
      'conversionValue': conversionValue,
    });
  }

  void updatePostbackConversionValueCoarseValue(int conversionValue, String coarseValue) {
    _channel.invokeMethod('updatePostbackConversionValueCoarseValue', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
    });
  }

  void updatePostbackConversionValueCoarseValueLockWindow(int conversionValue, String coarseValue, bool lockWindow) {
    _channel.invokeMethod('updatePostbackConversionValueCoarseValue', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
      'lockWindow': lockWindow,
    });
  }

  void transaction(String productName, String currencyCode, double quantity, double unitPrice) {
    _channel.invokeMethod('transaction', {
      'productName': productName,
      'currencyCode': currencyCode,
      'quantity': quantity,
      'unitPrice': unitPrice,
    });
  }

  void transactionWithReceipt({
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
      _channel.invokeMethod('transactionWithReceipt', {
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

  Future<Map<String, dynamic>?> getAttributionInfo() async {
    try {
      final dynamic response = await _channel.invokeMethod('getAttributionInfo');
      if (response is Map<String, dynamic>) {
        return response;
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

  void setCustomerUserId(String userId) {
    _channel.invokeMethod('setCustomerUserId', {'userId': userId});
  }

  void setCacheEventSetting(bool setting) {
    _channel.invokeMethod('setCacheEventSetting', {'setting': setting});
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

  void eventAdImpressionAdMob(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionAdMob', json);
  }

  void eventAdImpressionAppLovin(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionAppLovin', json);
  }

  void eventAdImpressionHyperBid(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionHyperBid', json);
  }

  void eventAdImpressionIronSource(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionIronSource', json);
  }
  
  void eventAdImpressionTopOn(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionTopOn', json);
  }

  void eventAdImpressionTradPlus(Map<String, dynamic> json) {
    _channel.invokeMethod('eventAdImpressionTradPlus', json);
  }

  void eventAdImpressionTradPlusAdInfo(Map<String, dynamic> json) {
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
    
    _channel.invokeMethod('eventAdImpressionTradPlus', transformedJson);
  }
}
