import 'package:flutter/material.dart';

import '../../../app/config/app_language.dart';
import '../../../core/presentation/build_context_extensions.dart';
import 'settings_item_row.dart';

class LanguageSelection extends StatelessWidget {
  final AppLanguage? selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const LanguageSelection({
    super.key,
    this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    void onCheckedChanged(bool? checked, AppLanguage language) {
      if (checked ?? false) onLanguageChanged.call(language);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SettingsItemRow(
          label: context.tr.english,
          isChecked: selectedLanguage == AppLanguage.english,
          onChanged: (checked) => onCheckedChanged(
            checked,
            AppLanguage.english,
          ),
        ),
        SettingsItemRow(
          label: context.tr.ukrainian,
          isChecked: selectedLanguage == AppLanguage.ukrainian,
          onChanged: (checked) => onCheckedChanged(
            checked,
            AppLanguage.ukrainian,
          ),
        ),
      ],
    );
  }
}
