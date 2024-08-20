import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/exceptions/platform_not_supported_error.dart';
import 'adaptive_bottom_popup_action_data.dart';

Future<void> showAdaptiveBottomPopup({
  required BuildContext context,
  required List<AdaptiveBottomPopupActionData> actions,
}) {
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => _showMaterialBottomSheet(
        context,
        actions,
      ),
    TargetPlatform.iOS => _showCupertinoModalPopup(
        context,
        actions,
      ),
    _ => throw PlatformNotSupportedError(),
  };
}

Future<void> _showMaterialBottomSheet(
  BuildContext context,
  List<AdaptiveBottomPopupActionData> actions,
) {
  return showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...actions.map((action) => TextButton(
                key: action.key,
                onPressed: () {
                  action.onPress.call(ctx);
                },
                child: Text(action.text),
              ))
        ],
      );
    },
  );
}

Future<void> _showCupertinoModalPopup(
  BuildContext context,
  List<AdaptiveBottomPopupActionData> actions,
) {
  return showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      return CupertinoActionSheet(
        actions: actions
            .map((action) => CupertinoActionSheetAction(
                  onPressed: () {
                    action.onPress.call(ctx);
                  },
                  isDestructiveAction: action.isDestructiveAction,
                  child: Text(action.text),
                ))
            .toList(),
      );
    },
  );
}
