import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  // 单例实例
  static AppStateProvider? _instance;

  // 私有构造函数
  AppStateProvider._();

  // 获取单例实例
  static AppStateProvider get instance {
    _instance ??= AppStateProvider._();
    return _instance!;
  }

  factory AppStateProvider() {
    _instance ??= AppStateProvider._();
    return _instance!;
  }

  Future<void> load() async {
    await _load();
    notifyListeners();
  }

  Future<void> save() async {
    await _save();
  }

  // 防抖保存
  Timer? _saveTimer;

  void _scheduleSave() {
    _saveTimer?.cancel(); // 取消上一次定时器
    _saveTimer = Timer(const Duration(milliseconds: 300), _save); // 防抖 300ms
  }

  /// 最后一次输入的消息
  String lastMessage = "";

  /// 最后一次搜索的关键词
  String lastSearch = "";

  /// 最后一次登录的用户邮箱
  String lastUserEmail = "";

  /// 最后一次登录的用户密码
  String lastUserPassword = "";

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMessage', lastMessage);
    await prefs.setString('lastSearch', lastSearch);

    await prefs.setString('lastUserEmail', lastUserEmail);
    await prefs.setString('lastUserPassword', lastUserPassword);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    lastMessage = prefs.getString('lastMessage') ?? "";
    lastSearch = prefs.getString('lastSearch') ?? "";
    lastUserEmail = prefs.getString('lastUserEmail') ?? "";
    lastUserPassword = prefs.getString('lastUserPassword') ?? "";

    notifyListeners();
  }
}
