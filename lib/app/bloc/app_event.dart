part of 'app_bloc.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.initialized() = _Initialized;

  const factory AppEvent.userStatusChanged({
    required bool isLoggedIn,
  }) = _UserStatusChanged;

  const factory AppEvent.themeChanged({
    required AppThemeMode appThemeMode,
  }) = _ThemeChanged;

  const factory AppEvent.languageChanged({
    required AppLanguage appLanguage,
  }) = _LanguageChanged;
}
