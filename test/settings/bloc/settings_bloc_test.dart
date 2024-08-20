import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/app/config/app_theme_mode.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/settings/bloc/settings_bloc.dart';
import 'package:expenses_tracker/settings/domain/use_case/delete_account_use_case.dart';
import 'package:expenses_tracker/settings/domain/use_case/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import '../../mocks/repository_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';

void main() {
  late SettingsBloc settingsBloc;
  late LogoutUseCase logoutUseCase;
  late SettingsRepository settingsRepository;
  late DeleteAccountUseCase deleteAccountUseCase;
  late AuthRepository authRepository;

  setUp(() {
    provideDummy<Either<Failure, void>>(const Right(null));

    logoutUseCase = MockLogoutUseCase();
    settingsRepository = MockSettingsRepository();
    deleteAccountUseCase = MockDeleteAccountUseCase();
    authRepository = MockAuthRepository();
    settingsBloc = SettingsBloc(
      logoutUseCase: logoutUseCase,
      settingsRepository: settingsRepository,
      deleteAccountUseCase: deleteAccountUseCase,
      authRepository: authRepository,
    );
  });

  blocTest(
    'test settings bloc default state is correct',
    build: () => settingsBloc,
    act: (bloc) {
      bloc.add(const SettingsEvent.initialized());
    },
    expect: () {
      return <SettingsState>[
        const SettingsState(
          appThemeMode: AppThemeMode.system,
          language: AppLanguage.english,
        ),
      ];
    },
    tearDown: () => settingsBloc.close(),
  );

  blocTest(
    'test theme change emits correct state',
    build: () => settingsBloc,
    act: (bloc) {
      bloc.add(
        const SettingsEvent.themeChanged(themeMode: AppThemeMode.light),
      );
    },
    expect: () {
      return <SettingsState>[
        const SettingsState(appThemeMode: AppThemeMode.light),
      ];
    },
    verify: (bloc) {
      verify(settingsRepository.saveThemeMode(AppThemeMode.light.name))
          .called(1);
    },
    tearDown: () => settingsBloc.close(),
  );

  blocTest(
    'test language change emits correct state',
    build: () => settingsBloc,
    act: (bloc) {
      bloc.add(
        const SettingsEvent.languageChanged(
          appLanguage: AppLanguage.ukrainian,
        ),
      );
    },
    expect: () {
      return <SettingsState>[
        const SettingsState(language: AppLanguage.ukrainian),
      ];
    },
    verify: (bloc) {
      verify(settingsRepository.saveCurrentLocale(AppLanguage.ukrainian.code))
          .called(1);
    },
    tearDown: () => settingsBloc.close(),
  );

  blocTest(
    'test logout is correct',
    build: () => settingsBloc,
    act: (bloc) {
      bloc.add(const SettingsEvent.logout());
    },
    verify: (_) {
      verify(logoutUseCase.execute(null)).called(1);
    },
    tearDown: () => settingsBloc.close(),
  );

  blocTest(
    'test delete account is correct',
    build: () => settingsBloc,
    setUp: () {
      when(authRepository.getCurrentUser()).thenReturn(fakeUser);
    },
    act: (bloc) {
      bloc.add(const SettingsEvent.deleteAccount());
    },
    verify: (_) {
      verify(deleteAccountUseCase.execute(fakeUser.uid!)).called(1);
    },
    tearDown: () => settingsBloc.close(),
  );
}
