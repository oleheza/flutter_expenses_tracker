import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/exceptions/platform_not_supported_error.dart';

typedef AdaptivePlatformBuilder<T> = T Function(BuildContext context);

abstract class BaseAdaptiveWidget<Material extends Widget,
    Cupertino extends Widget> extends StatelessWidget {
  const BaseAdaptiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => createMaterialWidget(context),
      TargetPlatform.iOS => createCupertinoWidget(context),
      _ => throw PlatformNotSupportedError()
    };
  }

  Material createMaterialWidget(BuildContext context);

  Cupertino createCupertinoWidget(BuildContext context);
}
