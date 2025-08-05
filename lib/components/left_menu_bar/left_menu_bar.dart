import 'package:flutter/material.dart';
import '../../components/left_menu_bar/left_menu_item.dart';

class LeftMenuBar extends StatefulWidget {
  final String title;
  final bool isWideScreen;
  final bool isInDrawer;
  final List<LeftMenuItem> menuItems;
  final void Function()? onMenuItemTap;

  const LeftMenuBar({
    super.key,
    required this.title,
    required this.menuItems,
    this.isWideScreen = false,
    this.isInDrawer = false,
    this.onMenuItemTap,
  });

  @override
  State<LeftMenuBar> createState() => _LeftMenuBarState();
}

class _LeftMenuBarState extends State<LeftMenuBar> {
  final double miniModeWidth = 48;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isWideScreen ? 300 : miniModeWidth, // 或任意你想要的宽度
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          // 菜单项
          ...widget.menuItems.map((item) {
            return widget.isWideScreen
                ? ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    selected: item.active,
                    onTap: () {
                      onTap(item);
                    },
                  )
                : Center(
                    child: IconButton(
                      onPressed: () {
                        onTap(item);
                      },
                      icon: Icon(item.icon),
                      tooltip: item.tooltip ?? item.title,
                      isSelected: item.active,
                    ),
                  );
          }),
        ],
      ),
    );
  }

  void onTap(LeftMenuItem item) {
    item.onPressed();
    // 如果是宽屏模式，点击后关闭 drawer
    // if (widget.isInDrawer) {
    //   Navigator.pop(context);
    // }
    widget.onMenuItemTap?.call();
  }

  Widget _buildDrawerHeader() {
    if (widget.isWideScreen) {
      return DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 36,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/ai_avatar_64x64.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // 更紧密填满裁剪区域
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      );
    }

    return Container(
      width: miniModeWidth,
      height: miniModeWidth,
      padding: EdgeInsetsGeometry.zero,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: const Icon(Icons.headphones),
    );
  }
}
