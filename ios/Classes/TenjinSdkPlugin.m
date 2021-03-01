#import "TenjinSdkPlugin.h"
#if __has_include(<tenjin_sdk/tenjin_sdk-Swift.h>)
#import <tenjin_sdk/tenjin_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tenjin_sdk-Swift.h"
#endif

@implementation TenjinSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTenjinSdkPlugin registerWithRegistrar:registrar];
}
@end
