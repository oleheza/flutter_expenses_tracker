import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/core/presentation/widgets/adaptive/adaptive_tab_scaffold.dart';
import 'package:expenses_tracker/create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import 'package:expenses_tracker/expenses/tabs/presentation/expenses_tabs_screen.dart';
import 'package:expenses_tracker/home/home_screen.dart';
import 'package:expenses_tracker/profile/edit/presentation/edit_profile_screen.dart';
import 'package:expenses_tracker/profile/view/presentation/profile_screen.dart';
import 'package:expenses_tracker/settings/domain/use_case/delete_account_use_case.dart';
import 'package:expenses_tracker/settings/domain/use_case/logout_use_case.dart';
import 'package:expenses_tracker/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../core/presentation/testable_widget.dart';
import '../mocks/repository_mocks.mocks.dart';
import '../mocks/third_party_mocks.mocks.dart';
import '../mocks/use_case_mocks.mocks.dart';
import 'home_screen_robot.dart';

void main() {
  late GoRouter goRouter;
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late ProfileRepository profileRepository;
  late ExpensesRepository expensesRepository;
  late LogoutUseCase logoutUseCase;
  late DeleteAccountUseCase deleteAccountUseCase;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    profileRepository = MockProfileRepository();
    expensesRepository = MockExpensesRepository();
    logoutUseCase = MockLogoutUseCase();
    deleteAccountUseCase = MockDeleteAccountUseCase();
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: HomeScreen(
        authRepository: authRepository,
        settingsRepository: settingsRepository,
        profileRepository: profileRepository,
        expensesRepository: expensesRepository,
        logoutUseCase: logoutUseCase,
        deleteAccountUseCase: deleteAccountUseCase,
      ),
    );
  }

  testWidgets(
    'test home screen has correct structure',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveTabScaffold));

      expect(find.text(context.tr.allExpenses), findsOneWidget);
      expect(find.text(context.tr.profile), findsOneWidget);
      expect(find.text(context.tr.settings), findsOneWidget);
    },
  );

  testWidgets(
    'test switching between home screen tabs is correct',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveTabScaffold));

      final robot = HomeScreenRobot(tester: tester, context: context);

      expect(find.byType(ExpensesTabsScreen), findsOneWidget);
      expect(find.byType(ProfileScreen), findsNothing);
      expect(find.byType(SettingsScreen), findsNothing);

      await robot.navigateToAddExpenses();
      verify(goRouter.pushNamed(CreateOrUpdateExpensesScreen.screenName));

      await robot.clickProfileTab();
      expect(find.byType(ExpensesTabsScreen), findsNothing);
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(SettingsScreen), findsNothing);

      await robot.navigateToEditProfile();
      verify(goRouter.pushNamed(EditProfileScreen.screenName)).called(1);

      await robot.clickSettingsTab();
      expect(find.byType(ExpensesTabsScreen), findsNothing);
      expect(find.byType(ProfileScreen), findsNothing);
      expect(find.byType(SettingsScreen), findsOneWidget);
    },
  );
}
