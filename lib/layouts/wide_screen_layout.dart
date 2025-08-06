import 'package:flutter/material.dart';
import '../components/top_app_bar.dart';
import '../components/left_menu_bar/left_menu_bar.dart';
import '../components/left_menu_bar/left_menu_item.dart';
import '../pages/default_page.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class WideScreenLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WideScreenLayoutState();

  final String title;
  final Map<String, Widget> pages;
  final List<LeftMenuItem> menuItems;
  // final List<Widget> actions;
  final Widget? drawer; // 可选的抽屉菜单
  final Widget? endDrawer; // 可选的抽屉菜单

  const WideScreenLayout({
    super.key,
    required this.title,
    required this.pages,
    required this.menuItems,
    // this.actions = const [],
    this.drawer,
    this.endDrawer,
  });
}

class _WideScreenLayoutState extends State<WideScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      body: SafeArea(
        child: Row(
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
                  TopAppBar(title: widget.title),
                  Flexible(
                    child:
                        widget.pages[Provider.of<UserProvider>(
                          context,
                        ).curPage] ??
                        const DefaultPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
