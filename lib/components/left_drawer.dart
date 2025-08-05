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
          if (widget.header != null)
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: widget.header!,
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          widget.child,
          const Divider(),
        ],
      ),
    );
  }
}
