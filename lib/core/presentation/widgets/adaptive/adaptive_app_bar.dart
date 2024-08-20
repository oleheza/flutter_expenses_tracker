import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

abstract class _BaseData {
  final Widget? leading;

  _BaseData({this.leading});
}

class MaterialAppBarData extends _BaseData {
  final List<Widget>? actions;
  final Widget? title;
  final bool centerTitle;

  MaterialAppBarData({
    super.leading,
    this.actions,
    this.title,
    this.centerTitle = false,
  });
}

class CupertinoAppBarData extends _BaseData {
  final Widget? middle;
  final Widget? trailing;

  CupertinoAppBarData({
    super.leading,
    this.trailing,
    this.middle,
  });
}

class AdaptiveAppBar extends BaseAdaptiveWidget<PreferredSizeWidget,
    ObstructingPreferredSizeWidget> {
  final AdaptivePlatformBuilder<MaterialAppBarData>? material;
  final AdaptivePlatformBuilder<CupertinoAppBarData>? cupertino;

  const AdaptiveAppBar({
    super.key,
    this.material,
    this.cupertino,
  });

  @override
  ObstructingPreferredSizeWidget createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return CupertinoNavigationBar(
      leading: data?.leading,
      middle: data?.middle,
      trailing: data?.trailing,
    );
  }

  @override
  PreferredSizeWidget createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return AppBar(
      leading: data?.leading,
      title: data?.title,
      centerTitle: data?.centerTitle,
      actions: data?.actions,
    );
  }
}
