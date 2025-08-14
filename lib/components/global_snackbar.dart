import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final List<_SnackbarWidgetState> _activeSnackbars = [];

  /// 全局显示 Snackbar
  static void show({
    required String message,
    Color backgroundColor = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (_navigatorKey.currentContext == null) return;
    final overlay = Overlay.of(_navigatorKey.currentContext!);
    

    final entry = OverlayEntry(
      builder: (context) {
        return _SnackbarWidget(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          duration: duration,
        );
      },
    );

    overlay.insert(entry);
  }

  // 全局 NavigatorKey
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}

/// Snackbar Widget
class _SnackbarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData? icon;
  final Duration duration;

  const _SnackbarWidget({
    Key? key,
    required this.message,
    required this.backgroundColor,
    this.icon,
    required this.duration,
  }) : super(key: key);

  @override
  _SnackbarWidgetState createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // 动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // 从屏幕底部滑入
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 添加到全局 active 列表
    GlobalSnackbar._activeSnackbars.add(this);

    _controller.forward();

    // 自动消失
    Future.delayed(widget.duration, () {
      _controller.reverse().then((_) {
        _removeSelf();
      });
    });
  }

  void _removeSelf() {
    if (mounted) {
      GlobalSnackbar._activeSnackbars.remove(this);
      if (context.findRenderObject() != null) {
        // 找到 OverlayEntry 并删除
        (context as Element).markNeedsBuild(); // 触发重绘
        Overlay.of(context)?.setState(() {}); // 保证 Overlay 更新
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 当前索引决定堆叠位置
    final index = GlobalSnackbar._activeSnackbars.indexOf(this);

    return Positioned(
      bottom: 20.0 + index * 60,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}