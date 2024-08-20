import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_app_bar.dart';
import 'base_adaptive_widget.dart';

class _BaseData {
  final Color? backgroundColor;

  _BaseData({this.backgroundColor});
}

class MaterialScaffoldData extends _BaseData {
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  MaterialScaffoldData({
    super.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });
}

class CupertinoScaffoldData extends _BaseData {
  CupertinoScaffoldData({super.backgroundColor});
}

final class AdaptiveScaffold
    extends BaseAdaptiveWidget<Scaffold, CupertinoPageScaffold> {
  final AdaptiveAppBar? appBar;

  final AdaptivePlatformBuilder<MaterialScaffoldData>? material;
  final AdaptivePlatformBuilder<CupertinoScaffoldData>? cupertino;
  final Widget child;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    this.material,
    this.cupertino,
    required this.child,
  });

  @override
  CupertinoPageScaffold createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return CupertinoPageScaffold(
      navigationBar: appBar?.createCupertinoWidget(context),
      backgroundColor: data?.backgroundColor,
      child: child,
    );
  }

  @override
  Scaffold createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return Scaffold(
      appBar: appBar?.createMaterialWidget(context),
      floatingActionButton: data?.floatingActionButton,
      floatingActionButtonLocation: data?.floatingActionButtonLocation,
      backgroundColor: data?.backgroundColor,
      body: child,
    );
  }
}
