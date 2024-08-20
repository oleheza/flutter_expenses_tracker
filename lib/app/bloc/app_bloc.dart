import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/domain/model/user_model.dart';
import '../../core/domain/repository/auth_repository.dart';
import '../../core/domain/repository/settings_repository.dart';
import '../config/app_language.dart';
import '../config/app_theme_mode.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;

  StreamSubscription<UserModel?>? _subscription;

  AppBloc({
    required this.authRepository,
    required this.settingsRepository,
  }) : super(AppState(isLoggedIn: authRepository.getCurrentUser() != null)) {
    on<AppEvent>(
      (event, emit) {
        event.when(
          initialized: () => _onInitialized(emit),
          themeChanged: (theme) => emit(state.copyWith(themeMode: theme)),
          languageChanged: (language) => emit(
            state.copyWith(appLanguage: language),
          ),
          userStatusChanged: (isLoggedIn) => emit(
            state.copyWith(isLoggedIn: isLoggedIn),
          ),
        );
      },
    );
    _subscription = authRepository.observeUserStatus().listen((user) {
      add(AppEvent.userStatusChanged(isLoggedIn: user != null));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onInitialized(Emitter<AppState> emit) {
    emit(
      state.copyWith(
        themeMode: getThemeModeByString(settingsRepository.getThemeMode()),
        appLanguage: getAppLanguageByString(
          settingsRepository.getCurrentLocale(),
        ),
      ),
    );
  }
}
