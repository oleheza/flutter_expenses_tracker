part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.initialized() = _Initialized;

  const factory SettingsEvent.logout() = _Logout;

  const factory SettingsEvent.deleteAccount() = _DeleteAccount;

  const factory SettingsEvent.themeChanged({
    required AppThemeMode themeMode,
  }) = _ThemeChanged;

  const factory SettingsEvent.languageChanged({
    required AppLanguage appLanguage,
  }) = _LanguageChanged;
}
