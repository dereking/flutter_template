import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text("Copyright Listenor"),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text("Twitter"),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text("email"),
            ],
          ),
        ],
      ),
    );
  }
}
