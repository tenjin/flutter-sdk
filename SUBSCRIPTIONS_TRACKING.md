# Tenjin – Flutter Subscription Tracking

**Add to your `pubspec.yaml`:**
```yaml
dependencies:
  tenjin_plugin: '1.3.0-beta.1'
```

Use `TenjinSDK.instance.subscription()` to track subscription purchases on **iOS** and **Android** and send purchase data to Tenjin for server-side verification and attribution.


### Method

```dart
void subscription({
  required String productId,
  required String currencyCode,
  required double unitPrice,
  String? iosTransactionId,
  String? iosOriginalTransactionId,
  String? iosReceipt,
  String? iosSKTransaction,
  String? androidPurchaseToken,
  String? androidPurchaseData,
  String? androidDataSignature,
})
```

## Examples

### iOS (StoreKit 2)

```dart
import 'dart:convert';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:tenjin_plugin/tenjin_sdk.dart';

InAppPurchase.instance.purchaseStream.listen((purchases) async {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased &&
        purchase is AppStorePurchaseDetails) {
      // Get product details for this purchase
      final response = await InAppPurchase.instance
          .queryProductDetails({purchase.productID});
      final product = response.productDetails.first;

      // App Store receipt (base64) for server verification
      final receipt = purchase.verificationData.serverVerificationData;

      // StoreKit 2 transaction JSON (string)
      List<SK2Transaction> transactions = await SK2Transaction.transactions();
      final SK2Transaction tx = transactions[0]; // use the first (latest) transaction
        (t) => t.productID == purchase.productID,
        orElse: () => throw Exception('Transaction not found for ${purchase.productID}'),
      );

      // Decode jsonRepresentation (Data) to String
      final jsonString = tx.jsonRepresentation;

      TenjinSDK.instance.subscription(
        productId: purchase.productID,
        currencyCode: product.currencyCode,
        unitPrice: product.rawPrice,
        iosTransactionId: tx.id.toString(),
        iosOriginalTransactionId: tx.originalId.toString(),
        iosReceipt: receipt,
        iosSKTransaction: jsonString,
      );

      await InAppPurchase.instance.completePurchase(purchase);
    }
  }
});
```

### Android (Google Play Billing)

```dart
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:tenjin_plugin/tenjin_sdk.dart';

// 1) Set up listener early (e.g., in initState)
InAppPurchase.instance.purchaseStream.listen((purchases) async {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased &&
        purchase is GooglePlayPurchaseDetails) {
      final PurchaseWrapper p = purchase.billingClientPurchase;

      // Get product details for this purchase
      final response = await InAppPurchase.instance
          .queryProductDetails({p.products.first});
      final product = response.productDetails.first;

      TenjinSDK.instance.subscription(
        productId: p.products.first,
        currencyCode: product.currencyCode,
        unitPrice: product.rawPrice,
        androidPurchaseToken: p.purchaseToken,
        androidPurchaseData: p.originalJson,
        androidDataSignature: p.signature,
      );

      await InAppPurchase.instance.completePurchase(purchase);
    }
  }
});
```
