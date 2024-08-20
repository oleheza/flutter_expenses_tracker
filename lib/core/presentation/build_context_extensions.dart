import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get materialTheme => Theme.of(this);

  CupertinoThemeData get cupertinoTheme => CupertinoTheme.of(this);

  AppLocalizations get tr => AppLocalizations.of(this)!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  void popIfCan() {
    if (canPop()) {
      pop();
    }
  }
}
