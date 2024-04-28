class ConfigService {
  static String? _defaultApiPath;

  static String get defaultApiPath => _defaultApiPath ?? "";

  static initialize() async {
    _defaultApiPath = "http://192.168.1.21:8080";
  }
}
