import 'package:flutter/material.dart';

import 'adaptive_dialog_action_data.dart';
import 'widgets/adaptive/adaptive_dialog_action_button.dart';

extension WidgetExtensions on Widget {
  void showLoader(
    BuildContext context,
    String text,
  ) {
    showAdaptiveDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog.adaptive(
          title: Text(text),
        );
      },
      barrierDismissible: false,
    );
  }

  Future<dynamic> showSimpleAdaptiveDialog({
    required BuildContext context,
    required String text,
    required List<AdaptiveDialogActionData> actions,
    bool barrierDismissible = false,
  }) {
    return _showAdaptiveDialog(
      context,
      Text(
        text,
      ),
      actions,
      barrierDismissible,
    );
  }

  Future<T?> _showAdaptiveDialog<T>(
    BuildContext context,
    Widget content,
    List<AdaptiveDialogActionData> actions,
    bool barrierDismissible,
  ) {
    return showAdaptiveDialog<T>(
      context: context,
      builder: (ctx) {
        return AlertDialog.adaptive(
          content: content,
          actions: actions
              .map(
                (e) => AdaptiveDialogActionButton(
                  key: e.key,
                  text: e.text,
                  onPress: () {
                    e.onPress(ctx);
                  },
                ),
              )
              .toList(),
        );
      },
      barrierDismissible: barrierDismissible,
    );
  }
}
