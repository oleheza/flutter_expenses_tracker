import 'package:flutter/material.dart';

import '../stateful_cupertino_segmented_control.dart';
import 'base_adaptive_widget.dart';

abstract class _BaseData {}

class MaterialTopTabBarData extends _BaseData {
  final int length;

  MaterialTopTabBarData({required this.length});
}

class CupertinoTopTabBarData extends _BaseData {
  final EdgeInsetsGeometry? tabsPadding;
  final List<String> tabsTags;

  CupertinoTopTabBarData({
    this.tabsPadding,
    required this.tabsTags,
  });
}

class AdaptiveTopTabBar extends BaseAdaptiveWidget<DefaultTabController,
    StatefulCupertinoSegmentedControl> {
  final List<String> labels;
  final List<Widget> children;
  final AdaptivePlatformBuilder<MaterialTopTabBarData> material;
  final AdaptivePlatformBuilder<CupertinoTopTabBarData>? cupertino;

  const AdaptiveTopTabBar({
    super.key,
    this.cupertino,
    required this.labels,
    required this.children,
    required this.material,
  });

  @override
  StatefulCupertinoSegmentedControl createCupertinoWidget(
    BuildContext context,
  ) {
    final data = cupertino?.call(context);

    return StatefulCupertinoSegmentedControl(
      tabsPadding: data?.tabsPadding,
      tabTags: data?.tabsTags ?? <String>[],
      labels: labels,
      children: children,
    );
  }

  @override
  DefaultTabController createMaterialWidget(BuildContext context) {
    final data = material.call(context);

    return DefaultTabController(
      length: data.length,
      child: Column(
        children: [
          TabBar(
            tabs: labels.map((e) => Tab(text: e)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
