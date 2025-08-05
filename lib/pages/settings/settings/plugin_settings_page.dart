import 'package:flutter/material.dart';
import '../../../providers/settings_provider.dart'; 
import 'package:provider/provider.dart';

class PluginSettingsPage extends StatelessWidget {
  const PluginSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsProvider>(context);
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.extension),
          title: const Text('插件管理'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: 导航到插件管理页面
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('自动更新插件'),
          subtitle: const Text('当有新版本时自动更新已安装的插件'),
          value: true,
          onChanged: (bool value) {
            // TODO: 更新自动更新设置
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('已安装插件'),
          subtitle: const Text('管理已安装的插件'),
        ),
        // 示例插件列表
        ListTile(
          leading: const Icon(Icons.extension_outlined),
          title: const Text('翻译插件'),
          subtitle: const Text('版本: 1.0.0'),
          trailing: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 打开插件设置
            },
          ),
        ),
      ],
    );
  }
}