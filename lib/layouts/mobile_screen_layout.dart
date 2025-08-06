import 'package:flutter/material.dart';
import '../pages/default_page.dart';
import '../components/top_app_bar.dart';
import '../providers/user_provider.dart';
import '../components/left_menu_bar/left_menu_item.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  final String title;
  final Widget? drawer; // 可选的抽屉菜单
  final Widget? endDrawer;
  final Map<String, Widget> pages;
  final List<LeftMenuItem> menuItems;

  // final List<Widget> actions;

  const MobileScreenLayout({
    super.key,
    required this.title,
    required this.pages,
    required this.menuItems,
    this.drawer,
    this.endDrawer,
    // this.actions = const [],
  });

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    _selectedIndex = index;
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.curPage = widget.pages.keys.elementAt(index);
  }

  void onMenuItemTap() {
    Navigator.pop(context); // 关闭 drawer
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      body: SafeArea(
        child: Column(
          children: [
            TopAppBar(title: widget.title),
            Flexible(
              child: widget.pages[provider.curPage] ?? const DefaultPage(),
            ),
          ],
        ),
      ), // 根据当前页面显示内容
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: widget.menuItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.title,
            tooltip: item.tooltip ?? item.title,
          );
        }).toList(), // 动态生成底部导航栏项
        //  const [
        //   BottomNavigationBarItem(icon: Icon(Icons.chat), label: '聊天'),
        //   BottomNavigationBarItem(
        //       icon: Icon(Icons.settings), label: 'Provider设置'),
        //   BottomNavigationBarItem(
        //       icon: Icon(Icons.settings), label: 'Prompts设置'),
        //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'MCP管理'),
        //   BottomNavigationBarItem(icon: Icon(Icons.info), label: '关于'),
        // ],
      ),
    );
  }
}
