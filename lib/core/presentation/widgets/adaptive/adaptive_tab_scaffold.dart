import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../material_tab_scaffold.dart';
import 'adaptive_app_bar.dart';
import 'base_adaptive_widget.dart';

abstract class _BaseData {
  final List<BottomNavigationBarItem> items;

  _BaseData({required this.items});
}

class MaterialTabScaffoldData extends _BaseData {
  FloatingActionButton? floatingActionButton;

  MaterialTabScaffoldData({
    required super.items,
    this.floatingActionButton,
  });
}

class CupertinoTabScaffoldData extends _BaseData {
  CupertinoTabScaffoldData({required super.items});
}

class AdaptiveTabScaffold
    extends BaseAdaptiveWidget<MaterialTabScaffold, CupertinoTabScaffold> {
  final AdaptiveAppBar? appBar;
  final ValueChanged<int?>? onTabSelected;
  final AdaptivePlatformBuilder<MaterialTabScaffoldData>? material;
  final AdaptivePlatformBuilder<CupertinoTabScaffoldData>? cupertino;

  final List<Widget> pages;

  const AdaptiveTabScaffold({
    super.key,
    this.appBar,
    this.onTabSelected,
    this.material,
    this.cupertino,
    required this.pages,
  });

  @override
  CupertinoTabScaffold createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: onTabSelected,
        items: data?.items ?? <BottomNavigationBarItem>[],
      ),
      tabBuilder: (ctx, index) {
        return CupertinoPageScaffold(
          navigationBar: appBar?.createCupertinoWidget(context),
          child: SafeArea(
            child: pages[index],
          ),
        );
      },
    );
  }

  @override
  MaterialTabScaffold createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return MaterialTabScaffold(
      appBar: appBar?.createMaterialWidget(context),
      floatingActionButton: data?.floatingActionButton,
      onTabSelected: onTabSelected,
      tabs: data?.items ?? <BottomNavigationBarItem>[],
      tabBuilder: (ctx, index) {
        return SafeArea(
          child: pages[index],
        );
      },
    );
  }
}
