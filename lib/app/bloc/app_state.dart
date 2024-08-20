part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoggedIn,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppLanguage.english) AppLanguage appLanguage,
  }) = _AppState;
}
