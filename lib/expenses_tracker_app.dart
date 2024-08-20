import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app/bloc/app_bloc.dart';
import 'app/config/router.dart';
import 'auth/presentation/auth_screen.dart';
import 'core/presentation/build_context_extensions.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/presentation/widgets/adaptive/adaptive_app.dart';

class ExpensesTrackerApp extends StatelessWidget {
  const ExpensesTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightAppTheme = AppTheme(brightness: Brightness.light);
    final darkAppTheme = AppTheme(brightness: Brightness.dark);

    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (previousState, state) =>
          previousState.isLoggedIn != state.isLoggedIn,
      listener: (ctx, state) {
        if (!state.isLoggedIn) {
          router.pushReplacementNamed(AuthScreen.screenName);
        }
      },
      buildWhen: (previousState, state) {
        return previousState.themeMode != state.themeMode ||
            previousState.appLanguage != state.appLanguage;
      },
      builder: (ctx, state) {
        return AdaptiveApp(
          material: (_) => MaterialAppData(
            appThemeMode: state.themeMode,
            lightThemeData: lightAppTheme.lightMaterialTheme,
            darkThemeData: darkAppTheme.darkMaterialTheme,
          ),
          cupertino: (_) => CupertinoAppData(
            appThemeMode: state.themeMode,
            cupertinoLightThemeData: lightAppTheme.getCupertinoTheme(context),
            cupertinoDarkThemeData: darkAppTheme.getCupertinoTheme(context),
          ),
          onGenerateTitle: (ctx) => ctx.tr.expensesTracker,
          locale: Locale(state.appLanguage.code),
          localizationDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          router: router,
        );
      },
    );
  }
}
