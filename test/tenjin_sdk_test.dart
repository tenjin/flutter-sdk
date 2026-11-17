import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenjin_plugin/tenjin_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('tenjin_plugin');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final getters = <String, Future<Map<String, dynamic>?> Function()>{
    'getAttributionInfo': TenjinSDK.instance.getAttributionInfo,
    'getUserProfileDictionary': TenjinSDK.instance.getUserProfileDictionary,
  };

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  for (final entry in getters.entries) {
    group(entry.key, () {
      test('normalizes native map keys and preserves nested values', () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          expect(call.method, entry.key);
          return <Object, Object>{
            7: 'value',
            'nested': <String, Object>{'count': 3},
          };
        });

        expect(await entry.value(), <String, dynamic>{
          '7': 'value',
          'nested': <String, Object>{'count': 3},
        });
      });

      test('returns an empty native map without treating it as an error',
          () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          expect(call.method, entry.key);
          return <String, Object>{};
        });

        expect(await entry.value(), isEmpty);
      });

      test('returns null for a malformed native response', () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          expect(call.method, entry.key);
          return 'not a map';
        });

        expect(await entry.value(), isNull);
      });

      test('returns null when the native SDK reports a platform error', () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          expect(call.method, entry.key);
          throw PlatformException(code: 'unavailable');
        });

        expect(await entry.value(), isNull);
      });
    });
  }
}
