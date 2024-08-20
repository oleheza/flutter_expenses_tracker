import 'package:expenses_tracker/app/bloc/app_bloc.dart';
import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/app/config/app_theme_mode.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/settings/domain/use_case/delete_account_use_case.dart';
import 'package:expenses_tracker/settings/domain/use_case/logout_use_case.dart';
import 'package:expenses_tracker/settings/presentation/settings_screen.dart';
import 'package:expenses_tracker/settings/presentation/settings_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../core/presentation/testable_widget.dart';
import '../../fake_data/fake_data.dart';
import '../../mocks/repository_mocks.mocks.dart';
import '../../mocks/third_party_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';
import 'settings_robot.dart';

void main() {
  late GoRouter goRouter;
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late LogoutUseCase logoutUseCase;
  late DeleteAccountUseCase deleteAccountUseCase;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    logoutUseCase = MockLogoutUseCase();
    deleteAccountUseCase = MockDeleteAccountUseCase();

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: BlocProvider(
        create: (context) => AppBloc(
          authRepository: authRepository,
          settingsRepository: settingsRepository,
        ),
        child: Scaffold(
          body: SettingsScreen(
            authRepository: authRepository,
            settingsRepository: settingsRepository,
            logoutUseCase: logoutUseCase,
            deleteAccountUseCase: deleteAccountUseCase,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'test logout is correct',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final robot = SettingsRobot(tester: tester);
      await robot.clickLogoutButton();

      verify(logoutUseCase.execute(any)).called(1);
    },
  );

  testWidgets(
    'test cancelled account deletion is correct',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(SettingsScreenContent));

      final robot = SettingsRobot(tester: tester);

      await robot.clickDeleteAccountButton();

      expect(
        find.text(context.tr.deleteAccountConfirmationMessage),
        findsOneWidget,
      );

      await robot.cancelAccountDeletion(context);

      verify(goRouter.pop()).called(1);
      verifyNever(deleteAccountUseCase.execute(fakeUser.uid!));
    },
  );

  testWidgets(
    'test confirmed account deletion is correct',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(SettingsScreenContent));

      final robot = SettingsRobot(tester: tester);

      await robot.clickDeleteAccountButton();

      expect(
        find.text(context.tr.deleteAccountConfirmationMessage),
        findsOneWidget,
      );

      await robot.confirmAccountDeletion(context);

      verify(deleteAccountUseCase.execute(fakeUser.uid!)).called(1);
    },
  );

  Future<void> testChangeLanguage(
    WidgetTester tester,
    int itemIndex,
    String expectedLanguageCode,
  ) async {
    await tester.pumpWidget(createTestableWidget());

    final robot = SettingsRobot(tester: tester);

    await robot.changeLanguage(itemIndex);

    verify(settingsRepository.saveCurrentLocale(expectedLanguageCode))
        .called(1);
  }

  testWidgets('test language switch  is correct', (tester) async {
    await testChangeLanguage(tester, 0, AppLanguage.english.code);
    await testChangeLanguage(tester, 1, AppLanguage.ukrainian.code);
  });

  Future<void> testThemeChange(
    WidgetTester tester,
    int itemIndex,
    String themeMode,
  ) async {
    await tester.pumpWidget(createTestableWidget());

    final robot = SettingsRobot(tester: tester);

    await robot.changeTheme(itemIndex);

    verify(settingsRepository.saveThemeMode(themeMode)).called(1);
  }

  testWidgets('test theme switch is correct', (tester) async {
    await testThemeChange(tester, 0, AppThemeMode.light.name);
    await testThemeChange(tester, 1, AppThemeMode.dark.name);
    await testThemeChange(tester, 2, AppThemeMode.system.name);
  });
}
