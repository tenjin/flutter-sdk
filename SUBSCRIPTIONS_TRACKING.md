# Tenjin – Flutter Subscription Tracking

Track subscription purchases with Tenjin for server-side verification and attribution.

## Installation

```yaml
dependencies:
  tenjin_plugin: '1.3.1'
```

Use `TenjinSDK.instance.subscription()` to track subscription purchases on **iOS** and send purchase data to Tenjin for server-side verification and attribution.

> **Note:** Subscription tracking is currently only available on iOS. Android support is coming soon.


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
);
```

---

## Using `in_app_purchase` (Direct Integration, iOS only)

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


---

## Helper Methods (iOS only)

### `subscriptionWithStoreKit`

Fetches the latest StoreKit 2 transaction for a product and sends it to Tenjin in a single native call. No SK2 data needs to be extracted in Dart. This is the recommended approach when your IAP library (e.g., RevenueCat, Adapty, Qonversion) doesn't expose SK2 transaction data.

```dart
await TenjinSDK.instance.subscriptionWithStoreKit(
  productId: 'com.example.monthly',
  currencyCode: 'USD',
  unitPrice: 9.99,
);
```

> **Note:** Requires iOS 15.0+ (StoreKit 2). This method is iOS-only and will no-op on Android.

---

## Using RevenueCat (purchases_flutter)

RevenueCat does not expose SK2 transaction data at the Dart level. Use `subscriptionWithStoreKit()` to handle everything natively — it fetches the SK2 transaction directly from StoreKit 2 and sends it to Tenjin in a single call.

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
        // Fetches SK2 transaction and sends to Tenjin natively
        await TenjinSDK.instance.subscriptionWithStoreKit(
          productId: product.identifier,
          currencyCode: product.currencyCode,
          unitPrice: product.price,
        );
      }
    }
  });
}
```
