import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

class AdaptiveTextButton
    extends BaseAdaptiveWidget<TextButton, CupertinoButton> {
  final Widget child;
  final VoidCallback onClick;

  const AdaptiveTextButton({
    super.key,
    required this.child,
    required this.onClick,
  });

  @override
  CupertinoButton createCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      onPressed: onClick,
      child: child,
    );
  }

  @override
  TextButton createMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      child: child,
    );
  }
}
