import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

class AdaptiveProgressIndicator extends BaseAdaptiveWidget<
    CircularProgressIndicator, CupertinoActivityIndicator> {

  const AdaptiveProgressIndicator({super.key});

  @override
  CupertinoActivityIndicator createCupertinoWidget(BuildContext context) {
    return const CupertinoActivityIndicator();
  }

  @override
  CircularProgressIndicator createMaterialWidget(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
