import 'package:flutter/widgets.dart';

import 'base_adaptive_widget.dart';

abstract class _BaseData {
  final Color? textColor;

  _BaseData({this.textColor});
}

class MaterialTextData extends _BaseData {
  MaterialTextData({super.textColor});
}

class CupertinoTextData extends _BaseData {
  CupertinoTextData({super.textColor});
}

class AdaptiveText extends BaseAdaptiveWidget<Text, Text> {
  final String text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final AdaptivePlatformBuilder<MaterialTextData>? material;
  final AdaptivePlatformBuilder<CupertinoTextData>? cupertino;

  const AdaptiveText({
    super.key,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.material,
    this.cupertino,
    required this.text,
  });

  @override
  Text createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return Text(
      text,
      textAlign: textAlign,
      style: textStyle?.copyWith(
        color: data?.textColor,
      ),
    );
  }

  @override
  Text createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return Text(
      text,
      textAlign: textAlign,
      style: textStyle?.copyWith(
        color: data?.textColor,
      ),
    );
  }
}
