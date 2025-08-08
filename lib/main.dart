import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; 
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
import 'providers/user_provider.dart';
import './vars.dart';
import 'package:provider/provider.dart';

import 'components/left_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLogger();

  // Stripe.publishableKey = 'pk_test_51PvwkJ05vKcIIxn04XhB3IS2qLKOvVvLKXvNIgMWtag96LHVrKphIIlDecXDaUKIr2PhOlQkH5KtKnTfqav6xhpz004aWNhzyu'; // 替换成你的 Stripe 公钥

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider.instance),
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<bool> _initializeApp() async {
    int count = 0;

    // 初始化应用信息
    await SettingsProvider.instance.load();
    await UserProvider.instance.load();
    await ThemeProvider.instance.load();

    debugPrint("UserProvider.load done");

    setState(() {
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

          locale: settingsProvider.locale,
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.appTitle;
          },

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
                        title: AppLocalizations.of(context)!.appTitle,
                        pages: _pages,
                        menuItems: getLeftMenuItems(context),
                        drawer: _drawer(),
                        endDrawer: _endDrawer(),
                      );
                    } else {
                      return MobileScreenLayout(
                        title: AppLocalizations.of(context)!.appTitle,
                        pages: _pages,
                        menuItems: getLeftMenuItems(context),
                        drawer: _drawer(),
                        endDrawer: _endDrawer(),
                      );
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _endDrawer() {
    return Builder(
      builder: (BuildContext context) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () {
                  UserProvider.instance.logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawer() {
    return LeftDrawer(
      title: 'Test',
      header: Text(
        'Drawer Header',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      child: Text("data"),
    );
  }

  static const Map<String, Widget> _pages = {
    "/home": DefaultPage(),
    "/settings": SettingsPage(),
    "/about": AboutPage(),
    "/login": LoginPage(),
  };

  List<LeftMenuItem> getLeftMenuItems(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return [
      LeftMenuItem(
        icon: provider.curPage == "/home" ? Icons.home : Icons.home_outlined,
        title: AppLocalizations.of(context)!.home,
        active: provider.curPage == "/home",
        onPressed: () {
          provider.curPage = '/home';
        },
      ),
      LeftMenuItem(
        icon: provider.curPage == "/settings"
            ? Icons.settings
            : Icons.settings_outlined,
        title: AppLocalizations.of(context)!.settings,
        active: provider.curPage == "/settings",
        onPressed: () {
          provider.curPage = '/settings';
        },
      ),
      LeftMenuItem(
        icon: provider.curPage == "/about" ? Icons.info : Icons.info_outlined,
        title: AppLocalizations.of(context)!.about,
        active: provider.curPage == "/about",
        onPressed: () {
          provider.curPage = '/about';
        },
      ),
    ];
  }
}
