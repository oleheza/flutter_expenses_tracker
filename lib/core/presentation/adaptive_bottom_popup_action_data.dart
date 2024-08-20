import 'package:flutter/cupertino.dart';

class AdaptiveBottomPopupActionData {
  final Key? key;
  final String text;
  final Function(BuildContext) onPress;
  final bool isDestructiveAction;

  AdaptiveBottomPopupActionData({
    required this.text,
    required this.onPress,
    this.key,
    this.isDestructiveAction = false,
  });
}
