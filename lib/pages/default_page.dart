import 'package:flutter/material.dart';  

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) { 
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '主要功能',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. 实时监听\n2. 语音识别\n3. 聊天记录保存',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              '常见会话案例',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. 会议记录\n2. 客户服务\n3. 语音备忘录',
              style: TextStyle(fontSize: 18),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // 创建新聊天的逻辑
 
                },
                child: const Text('创建新会话'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
