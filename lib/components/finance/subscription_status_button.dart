// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SubscriptionStatusButton extends StatefulWidget {
  final VoidCallback? onPressed; 

  const SubscriptionStatusButton({super.key, this.onPressed});

  @override
  State<SubscriptionStatusButton> createState() =>
      _SubscriptionStatusButtonState();
}

class _SubscriptionStatusButtonState extends State<SubscriptionStatusButton> {

  
  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        widget.onPressed?.call();
      },
      child: Text('订阅'),
    );
  }

  Widget _buildText() {
    return Text('订阅状态');
  }
}
