import 'package:flutter/material.dart';
import '../components/header_user_panel.dart';
import '../components/top_app_bar.dart';
import '../components/left_menu_bar/left_menu_bar.dart';
import '../components/left_menu_bar/left_menu_item.dart'; 
import '../pages/default_page.dart';
import '../providers/app_info_provider.dart'; 
import 'package:provider/provider.dart';

class WideScreenLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainFrameState();

  final String title;
  final Map<String, Widget> pages;
  final List<LeftMenuItem> menuItems;
  final List<Widget> actions;

  const WideScreenLayout({
    super.key,
    required this.title,
    required this.pages,
    required this.menuItems,
    this.actions = const [],
  });
}

class _MainFrameState extends State<WideScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Row(
        children: [
          // 左侧图标栏
          LeftMenuBar(
            title: widget.title,
            isWideScreen: false,
            menuItems: widget.menuItems,
          ),

          // 右侧分隔线
          const VerticalDivider(width: 1),
          // 右侧主内容
          Expanded(
            child: Column(
              children: [
                TopAppBar(
                  title: widget.title,
                  actions: const [
                    HeaderUserPanel(),
                  ],
                ),
                Flexible(
                  child: widget.pages[
                          Provider.of<AppInfoProvider>(context).curPage] ??
                      const DefaultPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
