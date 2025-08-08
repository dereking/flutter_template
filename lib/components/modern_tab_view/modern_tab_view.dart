import 'package:flutter/material.dart';
import '/services/storage_service.dart';
import './modern_tab_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ModernTabView extends StatefulWidget {
  final List<ModernTabViewPage> pages;
  final void Function(int)? onTabChanged;
  final int initialIndex;

  const ModernTabView({
    super.key,
    required this.pages,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  @override
  State<ModernTabView> createState() => _ModernTabViewState();
}

class _ModernTabViewState extends State<ModernTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late double _sidebarWidth =_minSidebarWidth;
  static const double _minSidebarWidth = 200.0;
  static const double _maxSidebarWidth = 400.0;
  static const String _sidebarWidthKey = 'modern_tab_view_sidebar_width';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.pages.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _loadSidebarWidth();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        
        widget.onTabChanged?.call(_tabController.index);
      }
      setState(() {}); // 添加这行强制刷新UI
    });
  }

  Future<void> _loadSidebarWidth() async { 
      _sidebarWidth = await StorageService().get<double>(_sidebarWidthKey, _minSidebarWidth);
    setState(()   { 
    });
  }

  Future<void> _saveSidebarWidth(double width) async {
    await StorageService().set<double>(_sidebarWidthKey, width); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧Tab栏
        Container(
          width: _sidebarWidth,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) {
                    final page = widget.pages[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _tabController.index == index
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: _tabController.index == index
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          page.icon,
                          color: _tabController.index == index
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        title: Text(
                          page.title,
                          style: TextStyle(
                            color: _tabController.index == index
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                        trailing: page.tail,
                        onTap: () => _tabController.animateTo(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        //拖动条
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _sidebarWidth = (_sidebarWidth + details.delta.dx)
                  .clamp(_minSidebarWidth, _maxSidebarWidth);
            });
          },
          onHorizontalDragEnd: (_) => _saveSidebarWidth(_sidebarWidth),
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Container(
              width: 1, // 设置为1像素宽度
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        // 右侧内容区
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages.map((page) => page.child).toList(),
          ),
        ),
      ],
    );
  }
}
