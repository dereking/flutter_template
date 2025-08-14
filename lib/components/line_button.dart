// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LineButton extends StatefulWidget {
  final VoidCallback onPress;
  final bool isLoading;

  final String text;
  final String? loadingText;

  const LineButton({
    super.key,
    required this.onPress,
    required this.isLoading,
    required this.text,
    this.loadingText,
  });

  @override
  State<LineButton> createState() => _LineButtonState();
}

class _LineButtonState extends State<LineButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: ElevatedButton(
        onPressed: widget.onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            if (widget.isLoading) Container(width: 15),
            Text(
              widget.isLoading
                  ? widget.loadingText ?? widget.text
                  : widget.text,
            ),
          ],
        ),
      ),
    );
  }
}
