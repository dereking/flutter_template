import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body:const Padding(
        padding:   EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
              'Listenor App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
              SizedBox(height: 16),
              Text(
              'Version：1.0.0',
              style: TextStyle(fontSize: 18),
            ),
              SizedBox(height: 8),
              Text(
              'Author：ZENKEE LLC',
              style: TextStyle(fontSize: 18),
            ),
              SizedBox(height: 16),
              Text(
              'Thanks for using Linsentor！',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}