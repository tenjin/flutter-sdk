#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tenjin_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tenjin_plugin'
  s.version          = '1.2.3'
  s.summary          = 'Tenjin Flutter SDK'
  s.description      = <<-DESC
A Flutter plugin to Tenjin SDK
                       DESC
  s.homepage         = 'https://pub.dev/packages/tenjin_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tenjin Engineering' => 'engineering@tenjin.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  s.swift_version = '5.1'
  
  s.static_framework = true
  s.frameworks = "AdSupport", "AppTrackingTransparency", "iAd", "StoreKit"

  s.xcconfig = { "OTHER_LINKER_FLAGS" => "-ObjC -all_load" }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.dependency 'TenjinSDK', '1.14.6'
end
