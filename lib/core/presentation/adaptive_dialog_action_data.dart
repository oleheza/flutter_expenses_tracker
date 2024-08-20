import 'package:flutter/widgets.dart';

class AdaptiveDialogActionData {
  final Key? key;
  final String text;
  final Function(BuildContext) onPress;

  AdaptiveDialogActionData({
    this.key,
    required this.text,
    required this.onPress,
  });
}
