import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/presentation/build_context_extensions.dart';

class SocialSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String svgIcon;
  final double iconSize;
  final Color? iconColor;

  const SocialSignInButton({
    super.key,
    required this.onPressed,
    required this.svgIcon,
    this.iconSize = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Color? color = iconColor;
    color ??= switch (defaultTargetPlatform) {
      TargetPlatform.android => context.materialTheme.colorScheme.primary,
      TargetPlatform.iOS => context.cupertinoTheme.primaryColor,
      _ => null
    };

    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: iconSize,
        width: iconSize,
        svgIcon,
      ),
    );
  }
}
