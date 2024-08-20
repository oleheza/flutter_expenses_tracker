import 'package:flutter/material.dart';

import '../../../app/config/app_theme_mode.dart';
import '../../../core/presentation/build_context_extensions.dart';
import 'settings_item_row.dart';

class ThemeSelection extends StatelessWidget {
  final AppThemeMode? selectedThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ThemeSelection({
    super.key,
    this.selectedThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    void onCheckedChanged(bool? isChecked, AppThemeMode appThemeMode) {
      if (isChecked ?? false) onThemeChanged(appThemeMode);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SettingsItemRow(
          label: context.tr.lightTheme,
          isChecked: selectedThemeMode == AppThemeMode.light,
          onChanged: (checked) => onCheckedChanged(checked, AppThemeMode.light),
        ),
        SettingsItemRow(
          label: context.tr.darkTheme,
          isChecked: selectedThemeMode == AppThemeMode.dark,
          onChanged: (checked) => onCheckedChanged(checked, AppThemeMode.dark),
        ),
        SettingsItemRow(
          label: context.tr.systemTheme,
          isChecked: selectedThemeMode == AppThemeMode.system,
          onChanged: (checked) =>
              onCheckedChanged(checked, AppThemeMode.system),
        ),
      ],
    );
  }
}
