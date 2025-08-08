import 'package:flutter/material.dart';
import '/providers/user_provider.dart';
import 'package:provider/provider.dart';
import './mini_icon_button.dart';
import './theme_setting_button.dart';
import '../l10n/app_localizations.dart';
import 'language_button.dart';
import 'user/login_status_dropdown_button.dart';

class TopAppBar extends StatefulWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

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
    UserProvider provider = Provider.of<UserProvider>(context);

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
                    tooltip: AppLocalizations.of(context)!.search,
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
              tooltip: AppLocalizations.of(context)!.search,
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (_showSearch) {
                    _searchFocusNode.requestFocus();
                  }
                });
              },
            ),
          LanguageButton(),
          ThemeSettingButton(),
          LoginStatusDropdownButton(
            user: Provider.of<UserProvider>(context).userSession,
            onTapLogin: () {
              Provider.of<UserProvider>(context, listen: false).gotoLogin();
            },
            onTapLogout: () {
              print("logout");
              Provider.of<UserProvider>(context, listen: false).logout();
            },
            onMySubscription: () {
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).navigateTo("/plans");
            },
          ),
          MiniIconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: AppLocalizations.of(context)!.moreAction,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
