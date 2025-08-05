import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  // ThemeProvider();
  // 单例实例
  static ThemeProvider? _instance;

  // 私有构造函数
  ThemeProvider._();

  // 获取单例实例
  static ThemeProvider get instance {
    _instance ??= ThemeProvider._();
    return _instance!;
  }

  factory ThemeProvider() {
    _instance ??= ThemeProvider._();
    return _instance!;
  }

  Future<bool> load() async {
    _themeSeedColor =
        await StorageService().getString('seedColor') ?? 'blueGrey';

    _themeMode =
        (await StorageService().getString("themeMode") ?? "system") == "system"
        ? ThemeMode.system
        : ThemeMode.light;
    return true;
  }

  void setThemeProvider(ThemeProvider tm) {
    _themeMode = tm.themeMode;
    _themeSeedColor = tm.themeSeedColor;
    notifyListeners();
  }

  String _themeSeedColor = 'blue';
  String get themeSeedColor => _themeSeedColor;
  void setThemeSeedColor(String color) async {
    _themeSeedColor = color;
    await StorageService().setString('seedColor', color);
    notifyListeners(); //通知依赖的Widget更新
  }

  // Color _themeColorSeed = Colors.blue;
  // Color get themeColorSeed => _themeColorSeed;

  // setThemeColorSeed(String themeColorSeed) {
  //   themeColorSeed = themeColorSeed;
  //   notifyListeners();
  // }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await StorageService().setString('themeMode', themeMode.name);
    notifyListeners();
  }
}

Map<String, Color> themeColorMap = {
  'red': Colors.redAccent,
  'orange': Colors.orange,
  'yellow': Colors.yellow,
  'green': Colors.green,
  'cyan': Colors.cyan,
  'blue': Colors.blue,
  'purple': Colors.purple,
  'indigo': Colors.indigo,
  'pink': Colors.pink,
  'teal': Colors.teal,
};

ThemeData _genRuiTheme({
  Brightness brightness = Brightness.dark,
  Color seedColor = Colors.blue,
  String font = "Noto Sans SC", // 修改默认字体名称
}) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ),
    useMaterial3: true,
    fontFamily: font,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 22),
      displayMedium: TextStyle(fontSize: 20),
      displaySmall: TextStyle(fontSize: 18),
      headlineLarge: TextStyle(fontSize: 18),
      headlineMedium: TextStyle(fontSize: 16),
      headlineSmall: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontSize: 14),
      titleMedium: TextStyle(fontSize: 12),
      titleSmall: TextStyle(fontSize: 10),
      bodyLarge: TextStyle(fontSize: 12),
      bodyMedium: TextStyle(fontSize: 12), // 主要文本默认大小
      bodySmall: TextStyle(fontSize: 10),
      labelLarge: TextStyle(fontSize: 12),
      labelMedium: TextStyle(fontSize: 10),
      labelSmall: TextStyle(fontSize: 9),
    ),
  );
}

ThemeData getThemeData(ThemeMode themeMode, String themeColor) {
  if (themeMode == ThemeMode.system) {
    // 使用 PlatformDispatcher 替代废弃的 window
    return _genRuiTheme(
      brightness:
          PlatformDispatcher.instance.platformBrightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      seedColor: themeColorMap[themeColor] ?? Colors.blueGrey,
    );
  }
  return _genRuiTheme(
    brightness: themeMode == ThemeMode.dark
        ? Brightness.dark
        : Brightness.light,
    seedColor: themeColorMap[themeColor] ?? Colors.blueGrey,
  );
}
