import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import 'package:expenses_tracker/expenses/list/presentation/expenses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/testable_widget.dart';
import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';
import '../../../mocks/third_party_mocks.mocks.dart';
import 'expenses_list_robot.dart';

void main() {
  late GoRouter goRouter;
  late AuthRepository authRepository;
  late ExpensesRepository expensesRepository;
  late SettingsRepository settingsRepository;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    expensesRepository = MockExpensesRepository();
    settingsRepository = MockSettingsRepository();

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: Scaffold(
        body: ExpensesListScreen(
          authRepository: authRepository,
          expensesRepository: expensesRepository,
          settingsRepository: settingsRepository,
        ),
      ),
    );
  }

  testWidgets(
    'test when no items displays a message',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value(<ExpenseModel>[]));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      final context = tester.element(find.byType(SafeArea));

      expect(find.text(context.tr.noExpensesAddYet), findsOneWidget);
    },
  );

  testWidgets(
    'test list view displays correct amount of headers and items',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value(<ExpenseModel>[fakeExpensesModel]));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate.estimatedChildCount, 2);
    },
  );

  testWidgets(
    'test list view item dismiss removes item',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value(<ExpenseModel>[fakeExpensesModel]));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      final robot = ExpensesListRobot(tester: tester);
      await robot.dismissExpensesItem(fakeExpensesModel.id!);

      verify(expensesRepository.deleteItem(
        fakeUser.uid!,
        fakeExpensesModel.id!,
      )).called(1);
    },
  );

  testWidgets(
    'test widget context menu edit item button is correct',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value(<ExpenseModel>[fakeExpensesModel]));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      final robot = ExpensesListRobot(tester: tester);

      await robot.longPressOnItem(fakeExpensesModel.id!);
      await robot.clickEditButton();

      verify(goRouter.pop()).called(1);
      verify(goRouter.pushNamed(
        CreateOrUpdateExpensesScreen.screenName,
        extra: fakeExpensesModel.id!,
      )).called(1);
    },
  );

  testWidgets(
    'test widget context menu cancel item button is correct',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value(<ExpenseModel>[fakeExpensesModel]));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      final robot = ExpensesListRobot(tester: tester);

      await robot.longPressOnItem(fakeExpensesModel.id!);
      await robot.clickCancelButton();

      verify(goRouter.pop()).called(1);
    },
  );
}
