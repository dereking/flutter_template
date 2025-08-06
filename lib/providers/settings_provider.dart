import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_template/services/storage_service.dart';
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

  // 语言设置
  Locale _locale = Locale('en', 'US');
  Locale get locale => _locale;
  set locale(Locale value) {
    _locale = value;
    notifyListeners();
    StorageService().set<Locale>("locale", value);
  }

  Future<void> load() async {
    try {
      _locale = await StorageService().get<Locale>(
        "locale",
        Locale('en', 'US'),
      );

      notifyListeners();
    } catch (e) {
      debugPrint("settingsProvider loadSettings Error:  ${e.toString()}");
    }
  }

  Future<void> save() async {
    try {
      // 保存语言设置
      await StorageService().set<Locale>("locale", _locale);
    } catch (e) {
      debugPrint("settingsProvider saveSettings Error:  ${e.toString()}");
    }
  }
}
