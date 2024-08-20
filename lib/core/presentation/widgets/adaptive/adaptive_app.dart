import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_theme_mode.dart';
import '../../build_context_extensions.dart';
import 'base_adaptive_widget.dart';

abstract class _BaseData {
  final AppThemeMode appThemeMode;

  _BaseData({required this.appThemeMode});
}

class MaterialAppData extends _BaseData {
  final ThemeData? lightThemeData;
  final ThemeData? darkThemeData;

  MaterialAppData({
    required super.appThemeMode,
    this.lightThemeData,
    this.darkThemeData,
  });
}

class CupertinoAppData extends _BaseData {
  final CupertinoThemeData? cupertinoLightThemeData;
  final CupertinoThemeData? cupertinoDarkThemeData;

  CupertinoAppData({
    required super.appThemeMode,
    this.cupertinoLightThemeData,
    this.cupertinoDarkThemeData,
  });
}

class AdaptiveApp extends BaseAdaptiveWidget<MaterialApp, CupertinoApp> {
  final GoRouter router;
  final AdaptivePlatformBuilder<MaterialAppData>? material;
  final AdaptivePlatformBuilder<CupertinoAppData>? cupertino;
  final Locale? locale;
  final List<Locale>? supportedLocales;
  final List<LocalizationsDelegate<dynamic>>? localizationDelegates;
  final String Function(BuildContext)? onGenerateTitle;

  const AdaptiveApp({
    super.key,
    this.cupertino,
    this.material,
    this.locale,
    this.localizationDelegates,
    this.supportedLocales,
    this.onGenerateTitle,
    required this.router,
  });

  @override
  CupertinoApp createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context);

    final lightTheme = data?.cupertinoLightThemeData;
    final darkTheme = data?.cupertinoDarkThemeData;
    final appThemeMode = data?.appThemeMode;

    final currentTheme = switch (appThemeMode) {
      AppThemeMode.light => lightTheme,
      AppThemeMode.dark => darkTheme,
      _ => context.mediaQuery.platformBrightness == Brightness.dark
          ? darkTheme
          : lightTheme
    };

    return CupertinoApp.router(
      onGenerateTitle: onGenerateTitle,
      routerConfig: router,
      theme: currentTheme,
      locale: locale,
      localizationsDelegates: localizationDelegates,
      supportedLocales: supportedLocales ?? <Locale>[],
    );
  }

  @override
  MaterialApp createMaterialWidget(BuildContext context) {
    final data = material?.call(context);

    final themeMode = switch (data?.appThemeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      _ => ThemeMode.system
    };

    return MaterialApp.router(
      onGenerateTitle: onGenerateTitle,
      routerConfig: router,
      theme: data?.lightThemeData,
      darkTheme: data?.darkThemeData,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: localizationDelegates,
      supportedLocales: supportedLocales ?? <Locale>[],
    );
  }
}
