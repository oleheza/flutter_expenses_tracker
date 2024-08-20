import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/config/app_language.dart';
import '../../app/config/app_theme_mode.dart';
import '../../core/domain/repository/auth_repository.dart';
import '../../core/domain/repository/settings_repository.dart';
import '../domain/use_case/delete_account_use_case.dart';
import '../domain/use_case/logout_use_case.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final SettingsRepository settingsRepository;
  final AuthRepository authRepository;

  SettingsBloc({
    required this.logoutUseCase,
    required this.settingsRepository,
    required this.deleteAccountUseCase,
    required this.authRepository,
  }) : super(const SettingsState()) {
    on<SettingsEvent>((event, emit) {
      event.when(
        initialized: () => _onInitialized(emit),
        themeChanged: (theme) => _onThemeChanged(emit, theme),
        languageChanged: (language) => _onLanguageChanged(emit, language),
        deleteAccount: () => _onDeleteAccount(),
        logout: () => _onLogout(),
      );
    });
  }

  void _onInitialized(Emitter<SettingsState> emit) {
    emit(
      SettingsState(
        appThemeMode: getThemeModeByString(settingsRepository.getThemeMode()),
        language: getAppLanguageByString(settingsRepository.getCurrentLocale()),
      ),
    );
  }

  void _onThemeChanged(Emitter<SettingsState> emit, AppThemeMode themeMode) {
    emit(state.copyWith(appThemeMode: themeMode));
    settingsRepository.saveThemeMode(themeMode.name);
  }

  void _onLogout() async {
    logoutUseCase.execute(null);
  }

  void _onDeleteAccount() async {
    final currentUserId = authRepository.getCurrentUser()?.uid ?? '';
    deleteAccountUseCase.execute(currentUserId);
  }

  void _onLanguageChanged(Emitter<SettingsState> emit, AppLanguage language) {
    emit(state.copyWith(language: language));
    settingsRepository.saveCurrentLocale(language.code);
  }
}
