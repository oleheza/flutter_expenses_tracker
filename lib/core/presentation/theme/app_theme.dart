import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  final Brightness brightness;

  AppTheme({
    required this.brightness,
  });

  ThemeData get lightMaterialTheme => ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.light(
          brightness: brightness,
          primary: AppColors.primaryColor,
        ),
      );

  ThemeData get darkMaterialTheme => ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.dark(
          brightness: brightness,
          primary: AppColors.primaryColor,
        ),
      );

  CupertinoThemeData getCupertinoTheme(BuildContext context) {
    final resolvedTextTheme = CupertinoTheme.of(context).textTheme;

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: AppColors.primaryColor,
      textTheme: resolvedTextTheme.copyWith(
        textStyle: GoogleFonts.nunito(
          color: const CupertinoDynamicColor.withBrightness(
            color: Colors.black,
            darkColor: Colors.white,
          ),
        ),
      ),
      applyThemeToAll: true,
    );
  }
}
