import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'base_adaptive_widget.dart';

abstract class _BaseData {
  final IconData icon;
  final Color? color;

  _BaseData({
    required this.icon,
    this.color,
  });
}

class MaterialAdaptiveIconData extends _BaseData {
  MaterialAdaptiveIconData({
    required super.icon,
    super.color,
  });
}

class CupertinoAdaptiveIconData extends _BaseData {
  CupertinoAdaptiveIconData({
    required super.icon,
    super.color,
  });
}

class AdaptiveIcon extends BaseAdaptiveWidget<Icon, Icon> {
  final AdaptivePlatformBuilder<MaterialAdaptiveIconData>? material;
  final AdaptivePlatformBuilder<CupertinoAdaptiveIconData>? cupertino;

  const AdaptiveIcon({
    super.key,
    this.material,
    this.cupertino,
  });

  @override
  Icon createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);
    return Icon(
      data?.icon,
      color: data?.color,
    );
  }

  @override
  Icon createMaterialWidget(BuildContext context) {
    final data = material?.call(context);
    return Icon(
      data?.icon,
      color: data?.color,
    );
  }
}
