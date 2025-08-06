import 'package:flutter/material.dart';

class MiniIconButton extends StatefulWidget {
  const MiniIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 20,
    this.selectedIcon,
    this.isSelected,
    this.pressCheckAnimation = true,
  });
  final double size;
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget? selectedIcon;

  final String tooltip;

  final bool? isSelected;

  final bool? pressCheckAnimation;
  //是否显示按钮点击后的check效果
  bool get showPressCheck =>
      (pressCheckAnimation == null) ? true : pressCheckAnimation!;

  @override
  State<StatefulWidget> createState() => _MiniIconButtonState();
}

class _MiniIconButtonState extends State<MiniIconButton> {
  // bool? isSelected = false;
  // bool? isDisabled = false;
  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
    // isSelected = widget.isSelected;
    // isDisabled = widget.isDisabled;
    // isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: IconButton(
        iconSize: widget.size - 2,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        icon: (widget.isSelected == null)
            ? ((isLoading ?? false) ? const Icon(Icons.check) : widget.icon)
            : widget.icon,
        onPressed: _onPressed,
        padding: const EdgeInsets.all(5),
        constraints: BoxConstraints(
          minWidth: widget.size,
          minHeight: widget.size,
        ),
        color: Theme.of(context).buttonTheme.colorScheme?.onSurface,
        selectedIcon: widget.selectedIcon,
        isSelected: widget.isSelected,
        tooltip: widget.tooltip,
        // selectedTooltip: widget.selectedTooltip,
      ),
    );
  }

  void _onPressed() {
    if (!widget.showPressCheck) {
      widget.onPressed?.call();
      return;
    }

    // Handle the button press
    setState(() {
      // Update the state if needed
      if (isLoading != null) {
        isLoading = true;
      }
    });

    try {
      widget.onPressed?.call();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } finally {}
  }
}
