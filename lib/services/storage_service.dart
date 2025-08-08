import 'dart:convert';
import 'dart:ui';

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

  Future<T> get<T>(String key, T defaultValue) async {
    final ps = await SharedPreferences.getInstance();
    if (T == String) {
      return ps.getString(key) as T? ?? defaultValue;
    } else if (T == int) {
      return ps.getInt(key) as T? ?? defaultValue;
    } else if (T == double) {
      return ps.getDouble(key) as T? ?? defaultValue;
    } else if (T == bool) {
      return ps.getBool(key) as T? ?? defaultValue;
    } else if (T == List<String>) {
      return ps.getStringList(key) as T? ?? defaultValue;
    } else if (T == Locale) {
      final langTag = ps.getString(key);
      return langTag != null
          ? Locale.fromSubtags(languageCode: langTag) as T
          : defaultValue;
    } else {
      return defaultValue; // 对于其他类型，返回默认值
    }
  }

  Future<void> set<T>(String key, T? value) async {
    final ps = await SharedPreferences.getInstance();
    if (value == null) {
      await ps.remove(key);
      return;
    }

    if (value is String) {
      await ps.setString(key, value);
    } else if (value is int) {
      await ps.setInt(key, value);
    } else if (value is double) {
      await ps.setDouble(key, value);
    } else if (value is bool) {
      await ps.setBool(key, value);
    } else if (value is List<String>) {
      await ps.setStringList(key, value);
    } else if (value is Locale) {
      await ps.setString(key, value.toLanguageTag());
    } else {
      final jsonString = json.encode(value);
      await ps.setString(key, jsonString);
    }
  }

  
}
