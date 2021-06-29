# [Flutter Tenjin SDK](https://tenjin.com/)

[![Pub Version](https://img.shields.io/pub/v/tenjin_sdk?color=blue)](https://pub.dev/packages/tenjin_sdk)
[![ISC License](https://img.shields.io/npm/l/vimdb?color=important)](LICENSE)

A Flutter plugin to Tenjin SDK

## ⚙️ Installation

**[Tenjin Docs](https://docs.tenjin.com/en/)**

1. Add the dependency to the `pubspec.yaml` file in your project:

```yaml
dependencies:
  tenjin_Sdk: any
```

2. Install the plugin by running the command below in the terminal, in your project's root directory:

```
$ flutter pub get
```

### Android

🔴🔴🔴🔴  To work in release you need to have Proguard configured. 🔴🔴🔴🔴

Manifest requirements:
```xml
<manifest>
  ...
  <uses-permission android:name="android.permission.INTERNET"></uses-permission>
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
  ...
</manifest>
```

If you haven’t already installed the [Google Play Services](https://developers.google.com/android/guides/setup), add it to our build.gradle file.
Starting with Tenjin Android SDK v1.8.3, you will need to add [Google's Install Referrer Library](https://developer.android.com/google/play/installreferrer/library.html).
```dart
dependencies {
  implementation 'com.google.android.gms:play-services-analytics:17.0.0'
  implementation 'com.android.installreferrer:installreferrer:1.1.2'
}
```

## 📱 Usage

### Initialization

Get your `API_KEY` from your [Tenjin Organization tab.](https://tenjin.io/dashboard/organizations)
You can initialize Tenjin with the function
```dart
TenjinSDK.instance.init(apiKey: '<API-KEY>');
```

You can verify if the integration is working through our [Live Test Device Data Tool](https://www.tenjin.io/dashboard/sdk_diagnostics). Add your `advertising_id` or `IDFA/GAID` to the list of test devices. You can find this under Support -> [Test Devices](https://www.tenjin.io/dashboard/debug_app_users).  Go to the [SDK Live page](https://www.tenjin.io/dashboard/sdk_diagnostics) and send a test events from your app.  You should see a live event come in:
![](https://s3.amazonaws.com/tenjin-instructions/sdk_live_purchase_events.png)



## 👮🏾‍♂️ GDPR compliance

Since iOS 14+ you are required to request a specific permission before you can have access to Apple's IDFA (a sort of proprietary cookie used by Apple to track users among multiple advertisers. To request this permission call the function TenjinSDK.instance.requestTrackingAuthorization():

```dart
<key>NSUserTrackingUsageDescription</key>
<string></string>
```

As part of GDPR compliance, with Tenjin's SDK you can opt-in, opt-out devices/users, or select which specific device-related params to opt-in or opt-out.  `OptOut()` will not send any API requests to Tenjin and we will not process any events.

```dart
TenjinSDK.instance.init(apiKey: '<API-KEY>');

bool userOptIn = checkOptInValue();

if (userOptIn) {
    TenjinSDK.instance.optIn();
} else {
    TenjinSDK.instance.optOut();
}

TenjinSDK.instance.connect();
```

To opt-in/opt-out specific device-related parameters, you can use the `OptInParams()` or `OptOutParams()`.  `OptInParams()` will only send device-related parameters that are specified.  `OptOutParams()` will send all device-related parameters except ones that are specified.  **Please note that we require at least `ip_address`, `advertising_id`, `developer_device_id`, `limit_ad_tracking`, `referrer` (Android), and `iad` (iOS) to properly track devices in Tenjin's system. If you plan on using Google, you will also need to add: `platform`, `os_version`, `locale`, `device_model`, and `build_id`.**

If you want to only get specific device-related parameters, use `OptInParams()`. In example below, we will only these device-related parameters: `ip_address`, `advertising_id`, `developer_device_id`, `limit_ad_tracking`, `referrer`, and `iad`:

```dart
TenjinSDK.instance.init(apiKey: '<API-KEY>');

List<String> optInParams = {"ip_address", "advertising_id", "developer_device_id", "limit_ad_tracking", "referrer", "iad"};
TenjinSDK.instance.optInParams(optInParams);

TenjinSDK.instance.connect();
```

If you want to send ALL parameters except specfic device-related parameters, use `OptOutParams()`.  In example below, we will send ALL device-related parameters except:


```dart
TenjinSDK.instance.init(apiKey: '<API-KEY>');

List<String> optOutParams = {"locale", "timezone", "build_id"};
TenjinSDK.instance.optOutParams(optOutParams);

TenjinSDK.instance.connect();
```

#### Device-Related Parameters

| Param  | Description | Reference |
| ------------- | ------------- | ------------- |
| ip_address  | IP Address | |
| advertising_id  | Device Advertising ID | [Android](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.html#getAdvertisingIdInfo(android.content.Context)) |
| limit_ad_tracking  | limit ad tracking enabled | [Android](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info.html#isLimitAdTrackingEnabled()) |
| platform | platform| Android |
| referrer | Google Play Install Referrer | [Android](https://developer.android.com/google/play/installreferrer/index.html) |
| os_version | operating system version | [Android](https://developer.android.com/reference/android/os/Build.VERSION.html#SDK_INT) |
| device | device name | [Android](https://developer.android.com/reference/android/os/Build.html#DEVICE) |
| device_manufacturer | device manufactuer | [Android](https://developer.android.com/reference/android/os/Build.html#MANUFACTURER) |
| device_model | device model | [Android](https://developer.android.com/reference/android/os/Build.html#MODEL) |
| device_brand | device brand | [Android](https://developer.android.com/reference/android/os/Build.html#BRAND) |
| device_product | device product | [Android](https://developer.android.com/reference/android/os/Build.html#PRODUCT) |
| carrier | phone carrier | [Android](https://developer.android.com/reference/android/telephony/TelephonyManager.html#getSimOperatorName()) |
| connection_type | cellular or wifi | [Android](https://developer.android.com/reference/android/net/ConnectivityManager.html#getActiveNetworkInfo()) |
| screen_width | device screen width | [Android](https://developer.android.com/reference/android/util/DisplayMetrics.html#widthPixels) |
| screen_height | device screen height | [Android](https://developer.android.com/reference/android/util/DisplayMetrics.html#heightPixels) |
| os_version_release | operating system version  | [Android](https://developer.android.com/reference/android/os/Build.VERSION.html#RELEASE) |
| build_id | build ID | [Android](https://developer.android.com/reference/android/os/Build.html) |
| locale | device locale | [Android](https://developer.android.com/reference/java/util/Locale.html#getDefault()) |
| country | locale country |[Android](https://developer.android.com/reference/java/util/Locale.html#getDefault()) |
| timezone | timezone | [Android](https://developer.android.com/reference/java/util/TimeZone.html) |

### 💵 Purchase Event

To understand user revenue and purchase behavior, developers can send `transaction` events to Tenjin. There are two ways to send `transaction` events to Tenjin.

#### Validate receipts
Tenjin can validate `transaction` receipts for you.

![Dashboard](https://s3.amazonaws.com/tenjin-instructions/android_pk.png "dashboard")

Example:
```dart
TenjinSDK.instance.transaction(
  ...
);
```

You can verify if the IAP validation is working through our [Live Test Device Data Tool](https://www.tenjin.io/dashboard/sdk_diagnostics).  You should see a live event come in:
![](https://s3.amazonaws.com/tenjin-instructions/sdk_live_purchase_events.png)

## Custom Event

NOTE: **DO NOT SEND CUSTOM EVENTS BEFORE THE INITIALIZATION** `connect()` event (above). The initialization event must come before any custom events are sent.

**IMPORTANT: Limit custom event names to less than 80 characters. Do not exceed 500 unique custom event names.**

You can use the Tenjin SDK to pass a custom event: `eventWithName(String name)`.

The custom interactions with your app can be tied to level cost from each acquisition source that you use through Tenjin's service. Here is an example of usage:

```dart
//Integrate a custom event with a distinct name - ie. swiping right on the screen
TenjinSDK.instance.eventWithName("swipe_right");

```

Passing custom events with integer values:

To pass a custom event with an integer value: `eventWithNameAndValue(String name, String value)` or `eventWithNameAndValue(String name, int value)`.

Passing an integer `value` with an event's `name` allows marketers to sum up and track averages of the values passed for that metric in the Tenjin dashboard. If you plan to use DataVault, these values can be used to derive additional metrics that can be useful.

```dart
TenjinSDK.instance.eventWithNameAndValue("item", 100);
```

Using the example above, the Tenjin dashboard will sum and average the values for all events with the name `item`.

Keep in mind that this event will not work if the value passed is not an integer.


### Deep Links
-------
Tenjin supports the ability to direct users to a specific part of your app after a new attributed install via Tenjin's campaign tracking URLs. You can utilize the `getDeeplink` method and callback to access the deferred deeplink through the data object. To test you can follow the instructions found [here](https://help.tenjin.io/t/how-do-i-use-and-test-deferred-deeplinks-with-my-campaigns/547)

```dart
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
```

Below are the parameters, if available, that are returned in the deferred deeplink callback:

| Parameter             | Description                                                      |
|-----------------------|------------------------------------------------------------------|
| advertising_id        | Advertising ID of the device                                     |
| ad_network            | Ad network of the campaign                                       |
| campaign_id           | Tenjin campaign ID                                               |
| campaign_name         | Tenjin campaign name                                             |
| site_id               | Site ID of source app                                            |
| referrer              | The referrer params from the app store                           |
| deferred_deeplink_url | The deferred deep-link of the campaign                           |
| clickedTenjinLink     | Boolean representing if the device was tracked by Tenjin         |
| isFirstSession        | Boolean representing if this is the first session for the device |

You can also use the v1.7.1+ SDK for handling post-install logic by checking the `isFirstSession` param. For example, if you have a paid app, you can register your paid app install in the following way:

```dart
TenjinSDK.instance.init(apiKey: '<API-KEY>');
TenjinSDK.instance.setRewardCallback = (bool clickedTenjinLink,
        bool isFirstSession, Map<String, String> data) {
      if (isFirstSession) {
          // send paid app price and revenue to Tenjin
      }
    };
```

App Subversion parameter for A/B Testing (requires DataVault)
-------

If you are running A/B tests and want to report the differences, we can append a numeric value to your app version using the `appendAppSubversion` method.  For example, if your app version `1.0.1`, and set `appendAppSubversion: @8888`, it will report as `1.0.1.8888`.

This data will appear within DataVault where you will be able to run reports using the app subversion values.

```
TenjinSDK.instance.init(apiKey: '<API-KEY>');
TenjinSDK.instance.appendAppSubversion(8888);
TenjinSDK.instance.connect();
```

ProGuard Settings:
----
```java
-keep class com.tenjin.** { *; }
-keep public class com.google.android.gms.ads.identifier.** { *; }
-keep public class com.google.android.gms.common.** { *; }
-keep public class com.android.installreferrer.** { *; }
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}
-keepattributes *Annotation*
```

## 📝 License

**Tenjin** is released under the ISC License. See [LICENSE](LICENSE) for details.

## 👨🏾‍💻 Author

Giovani Lobato ([GitHub](https://github.com/thize))
