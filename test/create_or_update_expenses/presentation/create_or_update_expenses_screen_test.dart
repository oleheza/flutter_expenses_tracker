import 'package:expenses_tracker/core/domain/extensions/date_time_extensions.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/add_expenses_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/get_expenses_by_id_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/update_expenses_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../core/presentation/testable_widget.dart';
import '../../fake_data/fake_data.dart';
import '../../mocks/repository_mocks.mocks.dart';
import '../../mocks/third_party_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';
import 'create_or_update_expenses_robot.dart';

void main() {
  late MockGoRouter goRouter;
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late AddExpensesUseCase addExpensesUseCase;
  late GetExpensesByIdUseCase getExpensesByIdUseCase;
  late UpdateExpensesUseCase updateExpensesUseCase;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    addExpensesUseCase = MockAddExpensesUseCase();
    getExpensesByIdUseCase = MockGetExpensesByIdUseCase();
    updateExpensesUseCase = MockUpdateExpensesUseCase();

    provideDummy<Either<Failure, void>>(const Right(null));

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
  });

  Widget createTestableWidget([String? originalExpensesId]) {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: CreateOrUpdateExpensesScreen(
        authRepository: authRepository,
        settingsRepository: settingsRepository,
        getExpensesByIdUseCase: getExpensesByIdUseCase,
        addExpensesUseCase: addExpensesUseCase,
        updateExpensesUseCase: updateExpensesUseCase,
        originalExpensesId: originalExpensesId,
      ),
    );
  }

  testWidgets(
    'test create expenses item is correct',
    (tester) async {
      final fakeCreatedExpensesModel = ExpenseModel(
        userId: fakeExpensesModel.userId,
        name: fakeExpensesModel.name,
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(fakeExpensesModel.timestamp)
                .toStartOfDay()
                .millisecondsSinceEpoch,
        amount: fakeExpensesModel.amount,
      );

      when(addExpensesUseCase.execute(fakeCreatedExpensesModel))
          .thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createTestableWidget());
      final context = tester.element(find.byType(AdaptiveScaffold));

      final robot = CreateOrUpdateExpensesRobot(tester: tester);

      expect(find.text(context.tr.addExpenses), findsOneWidget);

      await robot.enterExpensesName(fakeCreatedExpensesModel.name);
      await robot.enterExpensesPrice(
        fakeCreatedExpensesModel.amount.toString(),
      );
      await robot.showDatePicker();

      final date = DateTime.fromMillisecondsSinceEpoch(
        fakeCreatedExpensesModel.timestamp,
      );

      await robot.selectDate(
        date.day.toString(),
        context.tr.confirm,
      );

      await robot.clickSaveButton();

      verify(addExpensesUseCase.execute(fakeCreatedExpensesModel)).called(1);
      verify(goRouter.pop()).called(1);
    },
  );

  testWidgets(
    'test update expenses is correct',
    (tester) async {
      provideDummy<Either<Failure, ExpenseModel?>>(Right(fakeExpensesModel));

      final param = GetExpensesByIdParams(
        userId: fakeExpensesModel.userId,
        expensesId: fakeExpensesModel.id!,
      );

      const newName = 'new expenses';
      const double newAmount = 50;
      final newExpensesModel = ExpenseModel(
        id: fakeExpensesModel.id,
        userId: fakeExpensesModel.userId,
        name: newName,
        timestamp: fakeExpensesModel.timestamp,
        amount: newAmount,
      );

      when(getExpensesByIdUseCase.execute(param))
          .thenAnswer((_) async => Right(fakeExpensesModel));
      when(updateExpensesUseCase.execute(newExpensesModel))
          .thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createTestableWidget(fakeExpensesModel.id));
      final context = tester.element(find.byType(AdaptiveScaffold));
      final robot = CreateOrUpdateExpensesRobot(tester: tester);

      await tester.pump();

      expect(find.text(context.tr.editExpenses), findsOneWidget);
      expect(find.text(context.tr.edit), findsOneWidget);
      expect(find.text(fakeExpensesModel.name), findsOneWidget);
      expect(
        find.text(fakeExpensesModel.amount.toString()),
        findsOneWidget,
      );

      await robot.enterExpensesName(newName);
      await robot.enterExpensesPrice(newAmount.toString());
      await robot.clickSaveButton();

      verify(updateExpensesUseCase.execute(newExpensesModel)).called(1);
      verify(goRouter.pop()).called(1);
    },
  );
}
