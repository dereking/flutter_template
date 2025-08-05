import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../pages/default_page.dart';
import '../providers/theme_provider.dart';
import '../pages/login_page.dart';
import '../providers/settings_provider.dart';
import './components/left_menu_bar/left_menu_item.dart';
import './l10n/app_localizations.dart';
import './layouts/mobile_screen_layout.dart';
import './layouts/wide_screen_layout.dart';
import './pages/about_page.dart';
import './pages/settings_page.dart';
import './providers/app_info_provider.dart';
import './vars.dart';
import 'package:provider/provider.dart';

import 'components/left_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLogger();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoProvider.instance),
        ChangeNotifierProvider(create: (_) => SettingsProvider.instance),
        ChangeNotifierProvider(create: (_) => ThemeProvider.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<bool> _initializeApp() async {
    int count = 0;

    // 初始化应用信息
    await AppInfoProvider.instance.load();
    await ThemeProvider.instance.load();

    debugPrint("AppInfoProvider.load done");

    setState(() {
      _isInitialized = true;
      _isLoading = false;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final themeModel = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // 设置本地化代理
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // 设置支持的语言列表
          supportedLocales: AppLocalizations.supportedLocales,

          locale: Locale(settingsProvider.settings["languageCode"]),
          title: AppLocalizations.of(context)?.appTitle ?? 'Listenor',
          theme: getThemeData(
            themeProvider.themeMode,
            themeProvider.themeSeedColor,
          ),
          home: _isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return WideScreenLayout(
                        title:
                            AppLocalizations.of(context)?.appTitle ??
                            'Listenor',
                        pages: _pages,
                        menuItems: getLeftMenuItems(context),
                        drawer: _drawer,
                      );
                    } else {
                      return MobileScreenLayout(
                        title:
                            AppLocalizations.of(context)?.appTitle ??
                            'Listenor',
                        pages: _pages,
                        drawer: _drawer,
                        menuItems: getLeftMenuItems(context),
                      );
                    }
                  },
                ),
        );
      },
    );
  }

  Widget get _drawer {
    return LeftDrawer(
      title: 'Test',
      child: Text("data"),
      header: Text(
        'Drawer Header',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  static const Map<String, Widget> _pages = {
    "/home": DefaultPage(),
    "/settings": SettingsPage(),
    "/about": AboutPage(),
    "/login": LoginPage(),
  };

  List<LeftMenuItem> getLeftMenuItems(BuildContext context) {
    final provider = Provider.of<AppInfoProvider>(context);
    return [
      LeftMenuItem(
        icon: provider.curPage == "/home" ? Icons.home : Icons.home_outlined,
        title: 'Home',
        active: provider.curPage == "/home",
        onPressed: () {
          provider.curPage = '/home';
        },
      ),
      LeftMenuItem(
        icon: provider.curPage == "/settings"
            ? Icons.settings
            : Icons.settings_outlined,
        title: 'Settings',
        active: provider.curPage == "/settings",
        onPressed: () {
          provider.curPage = '/settings';
        },
      ),
      LeftMenuItem(
        icon: provider.curPage == "/about" ? Icons.info : Icons.info_outlined,
        title: 'About',
        active: provider.curPage == "/about",
        onPressed: () {
          provider.curPage = '/about';
        },
      ),
    ];
  }
}
