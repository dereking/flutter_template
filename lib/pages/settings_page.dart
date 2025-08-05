import 'package:flutter/material.dart';
import '../components/modern_tab_view/modern_tab_view_page.dart';
import '../components/modern_tab_view/modern_tab_view.dart';
import '../pages/settings/settings/advanced_settings_page.dart';
import '../pages/settings/settings/general_settings_page.dart';
import '../pages/settings/settings/plugin_settings_page.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin {
  final List<ModernTabViewPage> _pages = [
    ModernTabViewPage(
      title: 'General',
      icon: Icons.settings,
      child: const GeneralSettingsPage(),
    ),  
    ModernTabViewPage(
      title: 'Plugin',
      icon: Icons.build,
      child: const PluginSettingsPage(),
    ),
    ModernTabViewPage(
      title: 'Advanced',
      icon: Icons.admin_panel_settings,
      child: const AdvancedSettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ModernTabView(
        pages: _pages,
        onTabChanged: (index) {
          print("Tab changed to: $index");
        },
      ),
    );
  }
  
  @override 
  bool get wantKeepAlive => true;
}
