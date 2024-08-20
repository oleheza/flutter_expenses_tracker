import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double height;

  const VerticalSpacer({
    super.key,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
