// version_info.dart

class VersionInfo {
  final String version;
  final String dateTime;
  final String description;

  VersionInfo(this.version, this.dateTime, this.description);

  @override
  String toString() {
    return '$version | $dateTime || $description';
  }
}
