import 'package:flutter/material.dart';
import 'package:flutter_template/components/mini_icon_button.dart';
import 'package:flutter_template/components/theme_setting_button.dart';
import '../components/header_user_panel.dart';

class TopAppBar extends StatefulWidget {
  final String title;
  final List<Widget> actions;

  const TopAppBar({super.key, required this.title, this.actions = const []});

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  bool _showSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _showSearch = false; // 失去焦点时隐藏搜索框
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(32), // 设置高度
      child: AppBar(
        title: Text(widget.title),
        elevation: 1, // 取消阴影
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          if (_showSearch)
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    gapPadding: 2,
                  ),
                  suffixIcon: MiniIconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // 处理搜索逻辑
                      print('Searching for: ${_searchEditingController.text} ');
                    },
                  ),
                ),
                focusNode: _searchFocusNode,
                controller: _searchEditingController,
                onSubmitted: (value) {
                  // 处理搜索逻辑
                  print('Searching for: ${_searchEditingController.text} ');
                },
              ),
            ),
          if (!_showSearch)
            MiniIconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (_showSearch) {
                    _searchFocusNode.requestFocus();
                  }
                });
              },
            ),
          ThemeSettingButton(),
          const HeaderUserPanel(),
        ],
      ),
    );
  }
}
