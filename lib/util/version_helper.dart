/// Helper class for plugin version information.
///
/// IMPORTANT: Keep [version] in sync with the version in pubspec.yaml
/// when publishing new releases.
class VersionHelper {
  static const String version = '1.3.0';

  VersionHelper._();

  static String getVersion() => version;
}
