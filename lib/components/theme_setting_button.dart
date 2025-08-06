import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import '../components/mini_icon_button.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettingButton extends StatelessWidget {
  final Function(Color)? onThemeColorChange;

  final Function(ThemeMode)? onThemeModeChange;
  const ThemeSettingButton({
    super.key,
    this.onThemeModeChange,
    this.onThemeColorChange,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return MenuAnchor(
      // alignmentOffset: Offset(0, 0),
      menuChildren: [
        CheckboxMenuButton(
          closeOnActivate: false,
          value:
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.system,
          onChanged: (bool? value) {
            ThemeMode newMode = value ?? false
                ? ThemeMode.system
                : (isDark ? ThemeMode.dark : ThemeMode.light);
            Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).setThemeMode(newMode);
            if (onThemeModeChange != null) onThemeModeChange!(newMode);
          },
          child: Row(
            children: [
              const Text('深色模式跟随系统'),
              // if (Provider.of<ThemeProvider>(context).themeMode != ThemeMode.system)
              Switch(
                value: isDark,
                thumbIcon: WidgetStateProperty.all(
                  isDark
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode_outlined),
                ),
                onChanged: (bool value) {
                  print("ThemeSettingButton onChanged: $value");
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  if (onThemeModeChange != null) {
                    onThemeModeChange!(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  }
                },
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),
        ...themeColorMap.keys.map((key) {
          return MenuItemButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(themeColorMap[key]!),
            ),
            child: Row(
              children: [const Icon(Icons.color_lens_outlined), Text(key)],
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).setThemeSeedColor(key);
              if (onThemeColorChange != null) {
                onThemeColorChange!(themeColorMap[key]!);
              }
            },
          );
        }),
      ],

      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return MiniIconButton(
              // focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              tooltip: AppLocalizations.of(context)!.theme,
              icon: const Icon(Icons.palette),
            );
          },
    );
  }
}
