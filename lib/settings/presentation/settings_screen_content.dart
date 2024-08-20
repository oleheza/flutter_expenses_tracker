import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/bloc/app_bloc.dart';
import '../../app/config/app_language.dart';
import '../../app/config/app_theme_mode.dart';
import '../../core/presentation/adaptive_dialog_action_data.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widget_extensions.dart';
import '../../core/presentation/widget_keys.dart';
import '../../core/presentation/widgets/adaptive/adaptive_filled_button.dart';
import '../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../../core/presentation/widgets/vertical_spacer.dart';
import '../bloc/settings_bloc.dart';
import 'widgets/language_selection.dart';
import 'widgets/theme_selection.dart';

class SettingsScreenContent extends StatelessWidget {
  const SettingsScreenContent({super.key});

  void _addEvent(BuildContext context, SettingsEvent event) {
    context.read<SettingsBloc>().add(event);
  }

  void _addAppEvent(BuildContext context, AppEvent event) {
    context.read<AppBloc>().add(event);
  }

  void _showAccountDeletionConfirmation(BuildContext context) {
    showSimpleAdaptiveDialog(
      context: context,
      text: context.tr.deleteAccountConfirmationMessage,
      actions: <AdaptiveDialogActionData>[
        AdaptiveDialogActionData(
          text: context.tr.no,
          onPress: (ctx) => ctx.pop(),
        ),
        AdaptiveDialogActionData(
          text: context.tr.yesDelete,
          onPress: (ctx) {
            _addEvent(context, const SettingsEvent.deleteAccount());
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AdaptiveText(
            text: context.tr.appTheme,
            textAlign: TextAlign.start,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          BlocSelector<SettingsBloc, SettingsState, AppThemeMode?>(
            selector: (state) => state.appThemeMode,
            builder: (context, appThemeMode) {
              return ThemeSelection(
                selectedThemeMode: appThemeMode,
                onThemeChanged: (appThemeMode) {
                  _addEvent(
                    context,
                    SettingsEvent.themeChanged(themeMode: appThemeMode),
                  );
                  _addAppEvent(
                    context,
                    AppEvent.themeChanged(
                      appThemeMode: appThemeMode,
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          AdaptiveText(
            text: context.tr.language,
            textAlign: TextAlign.left,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          BlocSelector<SettingsBloc, SettingsState, AppLanguage?>(
            selector: (state) => state.language,
            builder: (context, language) {
              return LanguageSelection(
                selectedLanguage: language,
                onLanguageChanged: (language) {
                  _addEvent(
                    context,
                    SettingsEvent.languageChanged(appLanguage: language),
                  );
                  _addAppEvent(
                    context,
                    AppEvent.languageChanged(appLanguage: language),
                  );
                },
              );
            },
          ),
          const Divider(),
          AdaptiveFilledButton(
            key: WidgetKeys.settingsLogoutButtonKey,
            onClick: () {
              _addEvent(context, const SettingsEvent.logout());
            },
            child: Text(context.tr.logout),
          ),
          const VerticalSpacer(),
          AdaptiveFilledButton(
            key: WidgetKeys.settingsDeleteAccountButtonKey,
            onClick: () => _showAccountDeletionConfirmation(context),
            child: Text(context.tr.deleteMyAccount),
          )
        ],
      ),
    );
  }
}
