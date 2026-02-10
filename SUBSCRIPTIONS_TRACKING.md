# Tenjin – Flutter Subscription Tracking

Track subscription purchases with Tenjin for server-side verification and attribution.

## Installation

```yaml
dependencies:
  tenjin_plugin: '1.3.0-beta.1'
```

Use `TenjinSDK.instance.subscription()` to track subscription purchases on **iOS** and **Android** and send purchase data to Tenjin for server-side verification and attribution.


### Method

```dart
TenjinSDK.instance.subscription(
  productId: String,           // Required: Product ID
  currencyCode: String,        // Required: e.g., "USD"
  unitPrice: double,           // Required: e.g., 9.99
  // iOS parameters
  iosTransactionId: String?,
  iosOriginalTransactionId: String?,
  iosReceipt: String?,
  iosSKTransaction: String?,
  // Android parameters
  androidPurchaseToken: String?,
  androidPurchaseData: String?,
  androidDataSignature: String?,
);
```

---

## Using `in_app_purchase` (Direct Integration)

### iOS (StoreKit 2)

```dart
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:tenjin_plugin/tenjin_sdk.dart';

InAppPurchase.instance.purchaseStream.listen((purchases) async {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased &&
        purchase is AppStorePurchaseDetails) {

      // Get product details
      final response = await InAppPurchase.instance
          .queryProductDetails({purchase.productID});
      final product = response.productDetails.first;

      // Get receipt and transaction
      final receipt = purchase.verificationData.serverVerificationData;
      final transactions = await SK2Transaction.transactions();
      final tx = transactions.firstWhere(
        (t) => t.productID == purchase.productID,
        orElse: () => transactions.first,
      );

      TenjinSDK.instance.subscription(
        productId: purchase.productID,
        currencyCode: product.currencyCode,
        unitPrice: product.rawPrice,
        iosTransactionId: tx.id.toString(),
        iosOriginalTransactionId: tx.originalId.toString(),
        iosReceipt: receipt,
        iosSKTransaction: tx.jsonRepresentation,
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
import 'package:tenjin_plugin/tenjin_sdk.dart';

InAppPurchase.instance.purchaseStream.listen((purchases) async {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased &&
        purchase is GooglePlayPurchaseDetails) {

      final billing = purchase.billingClientPurchase;

      // Get product details
      final response = await InAppPurchase.instance
          .queryProductDetails({billing.products.first});
      final product = response.productDetails.first;

      TenjinSDK.instance.subscription(
        productId: billing.products.first,
        currencyCode: product.currencyCode,
        unitPrice: product.rawPrice,
        androidPurchaseToken: billing.purchaseToken,
        androidPurchaseData: billing.originalJson,
        androidDataSignature: billing.signature,
      );

      await InAppPurchase.instance.completePurchase(purchase);
    }
  }
});
```

---

## Using RevenueCat

If you're already using RevenueCat for paywalls, track purchases using the listener:

```dart
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tenjin_plugin/tenjin_sdk.dart';

// Set to avoid duplicate tracking
final Set<String> _trackedTransactions = {};

void setupRevenueCatListener() {
  Purchases.addCustomerInfoUpdateListener((customerInfo) async {
    for (final entitlement in customerInfo.entitlements.active.values) {
      final id = entitlement.productIdentifier;

      // Skip if already tracked
      if (_trackedTransactions.contains(id)) continue;
      _trackedTransactions.add(id);

      // Get product price from offerings
      final offerings = await Purchases.getOfferings();
      final products = offerings.current?.availablePackages
          .map((p) => p.storeProduct)
          .where((p) => p.identifier == id);
      final product = (products?.isNotEmpty ?? false) ? products!.first : null;

      if (product != null) {
        TenjinSDK.instance.subscription(
          productId: product.identifier,
          currencyCode: product.currencyCode,
          unitPrice: product.price,
        );
      }
    }
  });
}
```

---

## Best Practices

