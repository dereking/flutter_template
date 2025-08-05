import 'dart:convert';
import 'dart:io';

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
    "ApiBaseURL": "http://127.0.0.1:8080/api/v1",
    "MCPDownloadBaseURL": "https://static.listenor.app/", 
  };
  Map<String, dynamic> get settings {
    return _settings;
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
 

  String getMCPDownloadURL(String mcpName,String version) { 

    // 获取操作系统类型
    String os = Platform.isWindows
        ? 'windows'
        : Platform.isMacOS
            ? 'darwin'
            : Platform.isLinux
                ? 'linux'
                : 'windows';

    // 获取CPU架构
    String architect = Platform.version.contains('arm')
        ? 'arm64'
        : Platform.version.contains('x86')
            ? 'x86'
            : 'amd64';

    //https://static.listenor.app/mcp/mcpmath/1.0.0/mcpmath_1.0.0_darwin_amd64.zip
    return "${_settings['MCPDownloadBaseURL']}mcp/$mcpName/$version/${mcpName}_${version}_${os}_$architect.zip";
  }

  String getAPIBaseUrl() {
    print("$getAPIBaseUrl ${_settings["ApiBaseURL"]}");
    return _settings["ApiBaseURL"];
  }
}
