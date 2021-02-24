#import "TenjinAnalyticsPlugin.h"
#if __has_include(<tenjin_analytics/tenjin_analytics-Swift.h>)
#import <tenjin_analytics/tenjin_analytics-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tenjin_analytics-Swift.h"
#endif

@implementation TenjinAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTenjinAnalyticsPlugin registerWithRegistrar:registrar];
}
@end
