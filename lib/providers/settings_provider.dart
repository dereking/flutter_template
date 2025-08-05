import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // 单例实例
  static SettingsProvider? _instance;

  // 私有构造函数
  SettingsProvider._();

  // 获取单例实例
  static SettingsProvider get instance {
    _instance ??= SettingsProvider._();
    return _instance!;
  }

  factory SettingsProvider() {
    _instance ??= SettingsProvider._();
    return _instance!;
  }

  Map<String, dynamic> _settings = {
    "languageCode": "en_US",
    "ApiBaseURL": "http://127.0.0.1:8080/api/v1",
    "MCPDownloadBaseURL": "https://static.listenor.app/",
  };

  Map<String, dynamic> get settings {
    return _settings;
  }

  Locale _locale = Locale('en', 'US');
  Locale get locale {
    return _locale;
  }

  set locale(Locale value) {
    _locale = value;
    notifyListeners();
    saveItem("languageCode", value.languageCode);
  }

  dynamic get(String key) {
    return _settings[key];
  }

  void set(String key, dynamic value) {
    _settings[key] = value;
    notifyListeners();
    saveItem(key, value);
  }

  Future<void> load() async {
    try {
      if (kDebugMode) {
        print("settingsProvider loadSettings $_settings");
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // 从 SharedPreferences 中加载设置
      final String? settings = prefs.getString('settings');
      if (settings != null) {
        String settings = (prefs.getString('settings')) ?? '{}';
        // 解析设置并更新状态
        _settings = Map<String, dynamic>.from(json.decode(settings));
        notifyListeners();
      }

      if (kDebugMode) {
        print("settingsProvider loadSettings $_settings");
      }
    } catch (e) {
      debugPrint("settingsProvider loadSettings Error:  ${e.toString()}");
    }
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in _settings.keys) {
      await prefs.setString('settings-$key', json.encode(_settings[key]));
    }
  }

  Future<void> saveItem(String key, dynamic value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // 保存设置到 SharedPreferences
      await prefs.setString('settings-$key', json.encode(value));
    } catch (e) {
      debugPrint("settingsProvider saveSettings Error:  ${e.toString()}");
    }
  }
}
