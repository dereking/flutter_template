import 'package:flutter/material.dart';

class LeftDrawer extends StatefulWidget {
  final String title;
  final Widget? header;

  final Widget child;

  const LeftDrawer({
    super.key,
    required this.title,
    this.header,
    required this.child,
  });

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (widget.header != null) _buildDrawerHeader(), 
          widget.child,
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Column(
        children: [
          Row(
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
          widget.header != null
              ? widget.header!
              : const SizedBox.shrink(), // 如果没有 header，则不显示
        ],
      ),
    );
  }
}
