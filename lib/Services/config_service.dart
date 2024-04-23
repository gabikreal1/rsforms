class ConfigService {
  static String? _defaultApiPath;

  static String get defaultApiPath => _defaultApiPath ?? "";

  static initialize() async {
    _defaultApiPath = "http://localhost:3000";
  }
}
