import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/components/mini_icon_button.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../l10n/lang_code.dart';
import '../providers/settings_provider.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  final MenuController _menuController = MenuController();
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MenuAnchor(
      controller: _menuController,
      menuChildren: getLanguageMenuItems(),
      child: MiniIconButton(
        icon: Icon(Icons.translate),
        tooltip: 'Language',
        pressCheckAnimation: false,
        onPressed: () {
          _menuController.open();
        },
      ),
    );
  }

  List<Widget> getLanguageMenuItems() {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return AppLocalizations.supportedLocales.map((e) {
      return MenuItemButton(
        key: Key(e.languageCode),
        child: Row(
          children: [
            CountryFlag.fromLanguageCode(
              e.languageCode == "zh" ? "zh-cn" : e.languageCode,
              width: 28,
              height: 20,
            ),

            SizedBox(width: 8),
            Text(langCodeToLangName(e.languageCode)),
          ],
        ),
        onPressed: () {
          settingsProvider.locale = Locale(e.languageCode);
        },
      );
    }).toList();
  }
}
