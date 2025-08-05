import 'package:flutter/material.dart';
import '../../../providers/settings_provider.dart'; 
import 'package:provider/provider.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsProvider>(context);
    return ListView(
      children: [
        const ListTile(
          title: Text('高级设置'),
          subtitle: Text('这些设置可能会影响应用的性能和稳定性'),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('开发者模式'),
          subtitle: const Text('启用开发者调试功能'),
          value: false,
          onChanged: (bool value) {
            // TODO: 更新开发者模式设置
          },
        ), 
        const ExpansionTile(
          title: Text('网络设置'),
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: '代理服务器',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '代理端口',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        ListTile(
          title: const Text('导出设置'),
          subtitle: const Text('导出所有设置到文件'),
          trailing: const Icon(Icons.file_download),
          onTap: () {
            // TODO: 导出设置
          },
        ),
        ListTile(
          title: const Text('导入设置'),
          subtitle: const Text('从文件导入设置'),
          trailing: const Icon(Icons.file_upload),
          onTap: () {
            // TODO: 导入设置
          },
        ),
      ],
    );
  }
}
