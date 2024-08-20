import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/exceptions/platform_not_supported_error.dart';
import 'widgets/cupertino_date_picker_widget.dart';

Future<DateTime?> showAdaptiveDatePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  required String confirmText,
  required String cancelText,
  DateTime? initialDate,
}) {
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => _showMaterialDatePicker(
        context,
        initialDate,
        firstDate,
        lastDate,
        confirmText,
        cancelText,
      ),
    TargetPlatform.iOS => _showCupertinoDatePicker(
        context,
        initialDate,
        firstDate,
        lastDate,
        confirmText,
        cancelText,
      ),
    _ => throw PlatformNotSupportedError()
  };
}

Future<DateTime?> _showMaterialDatePicker(
  BuildContext context,
  DateTime? initialDate,
  DateTime firstDate,
  DateTime lastDate,
  String confirmText,
  String cancelText,
) {
  return showDatePicker(
    context: context,
    firstDate: firstDate,
    initialDate: initialDate,
    lastDate: lastDate,
    confirmText: confirmText,
    cancelText: cancelText,
  );
}

Future<DateTime?> _showCupertinoDatePicker(
  BuildContext context,
  DateTime? initialDate,
  DateTime firstDate,
  DateTime lastDate,
  String confirmText,
  String cancelText,
) {
  return showCupertinoModalPopup<DateTime?>(
    context: context,
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: CupertinoDatePickerWidget(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: confirmText,
          cancelText: cancelText,
        ),
      );
    },
  );
}
