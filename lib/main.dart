import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/pages/default_page.dart';
import 'package:flutter_template/providers/theme_provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _initializeApp() async {
    int count = 0;

    // 初始化应用信息
    await AppInfoProvider.instance.load();

    debugPrint("AppInfoProvider.load done");
 
 

    //延迟弹出，等主界面显示后。
    Future.delayed(const Duration(milliseconds: 500), () {
      // RuiApp.rootScaffoldMessengerKey.currentState?.showSnackBar(
      //   const SnackBar(
      //     content: Text('应用初始化成功'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
      title: AppLocalizations.of(context)?.appTitle ?? 'Listenor',
      theme:
                getThemeData(themeModel.themeMode, themeModel.themeSeedColor),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //     selectedItemColor: Colors.deepPurple,
      //     unselectedItemColor: Colors.grey,
      //   ),
      // ),
      darkTheme: ThemeData.dark().copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.white54,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError || (snapshot.data ?? false) == false) {
            return const Scaffold(
              body: Center(child: Text('应用初始化失败')),
            );
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return WideScreenLayout(
                    title: AppLocalizations.of(context)?.appTitle ?? 'Listenor',
                    pages: _pages,
                    menuItems: getLeftMenuItems(context),
                  );
                } else {
                  return MobileScreenLayout(
                    title: AppLocalizations.of(context)?.appTitle ?? 'Listenor',
                    pages: _pages,
                    menuItems: getLeftMenuItems(context),
                  );
                }
              },
            );
          }
        },
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
          icon: provider.curPage == "/home"
              ? Icons.home
              : Icons.home_outlined,
          title: 'Home',
          active: provider.curPage == "/home",
          onPressed: () {
            provider.curPage = '/home';
          }),
      LeftMenuItem(
          icon: provider.curPage == "/settings"
              ? Icons.settings
              : Icons.settings_outlined,
          title: 'Settings',
          active: provider.curPage == "/settings",
          onPressed: () {
            provider.curPage = '/settings';
          }),
      LeftMenuItem(
          icon: provider.curPage == "/about" ? Icons.info : Icons.info_outlined,
          title: 'About',
          active: provider.curPage == "/about",
          onPressed: () {
            provider.curPage = '/about';
          }),
    ];
  }
}
