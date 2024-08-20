import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

class AdaptiveDialogActionButton
    extends BaseAdaptiveWidget<TextButton, CupertinoDialogAction> {
  final String text;
  final VoidCallback onPress;

  const AdaptiveDialogActionButton({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  CupertinoDialogAction createCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPress,
      child: Text(text),
    );
  }

  @override
  TextButton createMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(text),
    );
  }
}
