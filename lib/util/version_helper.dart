/// Helper class for plugin version information.
///
/// The version below is kept in sync with pubspec.yaml by release-please;
/// do not edit it by hand.
class VersionHelper {
  // x-release-please-start-version
  static const String version = '1.5.0';
  // x-release-please-end

  VersionHelper._();

  static String getVersion() => version;
}
