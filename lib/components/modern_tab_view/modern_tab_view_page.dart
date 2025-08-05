
import 'package:flutter/material.dart';

class ModernTabViewPage {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? tail;

  ModernTabViewPage({
    required this.title,
    required this.icon,
    required this.child,
    this.tail,
  });
}