import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';

class SettingsItemRow extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const SettingsItemRow({
    super.key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AdaptiveText(text: label),
        Checkbox.adaptive(
          activeColor: defaultTargetPlatform == TargetPlatform.iOS
              ? context.cupertinoTheme.primaryColor
              : null,
          value: isChecked,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
