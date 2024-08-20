import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/app/bloc/app_bloc.dart';
import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/app/config/app_theme_mode.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import '../../mocks/repository_mocks.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late AppBloc appBloc;

  setUp(() {
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    appBloc = AppBloc(
      settingsRepository: settingsRepository,
      authRepository: authRepository,
    );
  });

  blocTest<AppBloc, AppState>(
    'test not logged in user provides correct state',
    build: () => AppBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
    ),
    setUp: () {
      when(authRepository.getCurrentUser()).thenAnswer((_) => null);
    },
    act: (bloc) => bloc.add(const AppEvent.initialized()),
    expect: () => <AppState>[const AppState(isLoggedIn: false)],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test logged in user provides correct state',
    build: () => AppBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
    ),
    setUp: () {
      when(authRepository.getCurrentUser()).thenAnswer((_) => fakeUser);
    },
    act: (bloc) => bloc.add(const AppEvent.initialized()),
    expect: () => <AppState>[const AppState(isLoggedIn: true)],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test app uses correct default theme',
    build: () => appBloc,
    setUp: () {
      when(settingsRepository.getThemeMode()).thenAnswer((_) => null);
    },
    act: (bloc) => bloc.add(const AppEvent.initialized()),
    expect: () => <AppState>[const AppState(themeMode: AppThemeMode.system)],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test app uses correct theme',
    build: () => appBloc,
    setUp: () {
      when(settingsRepository.getThemeMode()).thenAnswer(
        (_) => AppThemeMode.light.name,
      );
    },
    act: (bloc) => bloc.add(const AppEvent.initialized()),
    expect: () => <AppState>[const AppState(themeMode: AppThemeMode.light)],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test app updates theme properly',
    build: () => appBloc,
    act: (bloc) => bloc.add(
      const AppEvent.themeChanged(appThemeMode: AppThemeMode.dark),
    ),
    expect: () => <AppState>[const AppState(themeMode: AppThemeMode.dark)],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test app updates language properly',
    build: () => appBloc,
    act: (bloc) => bloc.add(
      const AppEvent.languageChanged(appLanguage: AppLanguage.ukrainian),
    ),
    expect: () => <AppState>[
      const AppState(
        appLanguage: AppLanguage.ukrainian,
      )
    ],
    tearDown: () => appBloc.close(),
  );

  blocTest<AppBloc, AppState>(
    'test user logout state updated properly',
    build: () => appBloc,
    act: (bloc) => bloc.add(
      const AppEvent.userStatusChanged(isLoggedIn: false),
    ),
    expect: () => <AppState>[
      const AppState(
        isLoggedIn: false,
      )
    ],
    tearDown: () => appBloc.close(),
  );

  blocTest(
    'test user state change provide correct result',
    build: () => AppBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
    ),
    setUp: () {
      when(authRepository.getCurrentUser()).thenAnswer((_) => fakeUser);
      when(authRepository.observeUserStatus())
          .thenAnswer((_) => Stream.value(null));
    },
    expect: (){
      return <AppState>[
        const AppState(),
      ];
    }
  );
}
