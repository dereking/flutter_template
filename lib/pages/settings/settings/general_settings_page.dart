import 'package:flutter/material.dart';
import '../../../providers/settings_provider.dart'; 
import 'package:provider/provider.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsProvider>(context);
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('主题'),
          trailing: DropdownButton<String>(
            value: '跟随系统',
            items: const [
              DropdownMenuItem(value: '跟随系统', child: Text('跟随系统')),
              DropdownMenuItem(value: '浅色', child: Text('浅色')),
              DropdownMenuItem(value: '深色', child: Text('深色')),
            ],
            onChanged: (value) {
              // TODO: 实现主题切换逻辑
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('界面语言'),
          trailing: DropdownButton<String>(
            value: '简体中文',
            items: const [
              DropdownMenuItem(value: '简体中文', child: Text('简体中文')),
              DropdownMenuItem(value: '英文', child: Text('英文')),
            ],
            onChanged: (value) {
              // TODO: 实现语言切换逻辑
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.keyboard),
          title: const Text('发送消息快捷键'),
          trailing: DropdownButton<String>(
            value: 'Enter',
            items: const [
              DropdownMenuItem(value: 'Enter', child: Text('Enter')),
              DropdownMenuItem(value: 'Ctrl+Enter', child: Text('Ctrl+Enter')),
            ],
            onChanged: (value) {
              // TODO: 实现快捷键设置逻辑
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.public),
          title: const Text('网络代理'),
          subtitle: TextField(
            decoration: const InputDecoration(
              hintText: '请输入代理地址',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            controller: TextEditingController(text: 'http://127.0.0.1:7897'),
            onChanged: (value) {
              // TODO: 实现代理设置逻辑
            },
          ),
        ),
      ],
    );
  }
}