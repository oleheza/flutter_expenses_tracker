import 'package:flutter/material.dart';

import '../../build_context_extensions.dart';
import 'base_adaptive_widget.dart';

class AdaptiveCircleAvatar
    extends BaseAdaptiveWidget<CircleAvatar, CircleAvatar> {
  final Widget child;
  final double? radius;

  const AdaptiveCircleAvatar({
    super.key,
    required this.child,
    this.radius,
  });

  @override
  CircleAvatar createCupertinoWidget(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.cupertinoTheme.primaryColor,
      radius: radius,
      child: child,
    );
  }

  @override
  CircleAvatar createMaterialWidget(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: child,
    );
  }
}
