import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_adaptive_widget.dart';

class MaterialOutlinedTextFieldData {
  final String? label;
  final Widget? prefixIcon;

  MaterialOutlinedTextFieldData({
    this.label,
    this.prefixIcon,
  });
}

class CupertinoOutlinedTextFieldData {
  final OverlayVisibilityMode? clearButtonMode;
  final Widget? prefix;

  CupertinoOutlinedTextFieldData({
    this.clearButtonMode,
    this.prefix,
  });
}

class AdaptiveOutlinedTextField
    extends BaseAdaptiveWidget<TextField, CupertinoTextField> {
  final bool obscureText;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final String? hint;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;
  final AdaptivePlatformBuilder<MaterialOutlinedTextFieldData>? material;
  final AdaptivePlatformBuilder<CupertinoOutlinedTextFieldData>? cupertino;

  const AdaptiveOutlinedTextField({
    super.key,
    this.textEditingController,
    this.hint,
    this.keyboardType,
    this.onChanged,
    this.material,
    this.cupertino,
    this.textInputAction,
    this.isEnabled = true,
    this.obscureText = false,
  });

  @override
  CupertinoTextField createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    return CupertinoTextField(
      keyboardType: keyboardType,
      placeholder: hint,
      enabled: isEnabled,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: textEditingController,
      textInputAction: textInputAction,
      prefix: data?.prefix,
      clearButtonMode: data?.clearButtonMode ?? OverlayVisibilityMode.never,
    );
  }

  @override
  TextField createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    return TextField(
      controller: textEditingController,
      keyboardType: keyboardType,
      enabled: isEnabled,
      onChanged: onChanged,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        label: data?.label != null ? Text(data!.label!) : null,
        hintText: hint,
        prefixIcon: data?.prefixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
