import 'package:flutter/material.dart';

class LeftMenuItem {
  final IconData icon;
  final String title;
  final String? tooltip;
  final bool active;
  final VoidCallback onPressed;

  LeftMenuItem({
    required this.icon,
    required this.title,
    this.tooltip,
    this.active = false,
    required this.onPressed,
  });
}
