import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

abstract class _BaseData {}

class MaterialFilledButtonData extends _BaseData {
  final ButtonStyle? style;

  MaterialFilledButtonData({
    this.style,
  });
}

class CupertinoFilledButtonData extends _BaseData {
  final EdgeInsetsGeometry? padding;

  CupertinoFilledButtonData({
    this.padding,
  });
}

class AdaptiveFilledButton
    extends BaseAdaptiveWidget<FilledButton, CupertinoButton> {
  final Widget child;
  final VoidCallback onClick;
  final bool enabled;
  final AdaptivePlatformBuilder<MaterialFilledButtonData>? material;
  final AdaptivePlatformBuilder<CupertinoFilledButtonData>? cupertino;

  const AdaptiveFilledButton({
    super.key,
    this.material,
    this.cupertino,
    this.enabled = true,
    required this.onClick,
    required this.child,
  });

  @override
  CupertinoButton createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return CupertinoButton.filled(
      padding: data?.padding,
      onPressed: enabled ? onClick : null,
      child: child,
    );
  }

  @override
  FilledButton createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return FilledButton(
      onPressed: enabled ? onClick : null,
      style: data?.style,
      child: child,
    );
  }
}
