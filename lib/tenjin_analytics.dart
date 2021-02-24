import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TenjinAnalytics {
  static const MethodChannel _channel = const MethodChannel('tenjin_analytics');

  static void connect({@required String apiKey}) {
    _channel.invokeMethod('connect', {
      'apiKey': apiKey,
      //TODO: optOutParams and optInParams
    });
  }

  static void sendCustomEvent({@required String name}) {
    _channel.invokeMethod('sendCustomEvent', {
      'name': name,
    });
  }

  static void sendCustomEventWithValue(
      {@required String name, @required String value}) {
    _channel.invokeMethod('sendCustomEventWithValue', {
      'name': name,
      'value': value,
    });
  }

  static void sendPurchaseEvent({
    @required String productId,
    @required String purchaseData,
    @required String dataSignature,
    @required String currencyCode,
    @required double unitPrice,
    @required int quantity,
  }) {
    _channel.invokeMethod('sendPurchaseEvent', {
      'productId': productId,
      'purchaseData': purchaseData,
      'dataSignature': dataSignature,
      'currencyCode': currencyCode,
      'unitPrice': unitPrice,
      'quantity': quantity,
    });
  }

  //TODO: deeplinkCallBack
  //TODO: https://github.com/tenjin/tenjin-android-sdk#tenjin-deferred-deeplink-integration-instructions

  //TODO: ProGuard Settings:
  //TODO: https://github.com/tenjin/tenjin-android-sdk#proguard-settings

  //TODO: App Subversion parameter for A/B Testing (requires DataVault):
  //TODO: https://github.com/tenjin/tenjin-android-sdk#app-subversion-parameter-for-ab-testing-requires-datavault
}
