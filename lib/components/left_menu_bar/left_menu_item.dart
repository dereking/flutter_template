
import 'package:flutter/material.dart';

class LeftMenuItem { 
  final IconData icon; 
  final String title;
  final bool active;
  final VoidCallback onPressed;

  LeftMenuItem({ 
    required this.icon, 
    required this.title,
    this.active = false,
    required this.onPressed,
  });
}