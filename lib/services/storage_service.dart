import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // 单例实例
  static StorageService? _instance;
  // 私有构造函数
  StorageService._();

  // 获取单例实例
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<String?> loadToken() async {
    final ps = await SharedPreferences.getInstance();
    final token = ps.getString("token");
    if (token == null) {
      return null;
    }
    return token;
  }

  Future<bool> saveToken(String? tk) async {
    final ps = await SharedPreferences.getInstance();
    if (tk == null) {
      return ps.remove("token");
    }
    return ps.setString("token", tk);
  }

  Future<void> setString(String key, String value) async {
    final ps = await SharedPreferences.getInstance();
    await ps.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final ps = await SharedPreferences.getInstance();
    return ps.getString(key);
  }
}
