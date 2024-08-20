import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/expenses/chart/presentation/expenses_chart_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/testable_widget.dart';
import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';
import '../../../mocks/third_party_mocks.mocks.dart';
import 'expenses_chart_robot.dart';

void main() {
  late GoRouter goRouter;
  late ExpensesRepository expensesRepository;
  late AuthRepository authRepository;

  final fakeExpensesModel2Date =
      DateTime.now().subtract(const Duration(days: 2));

  final fakeExpensesModel2 = ExpenseModel(
    id: '443546',
    userId: fakeUser.uid!,
    name: 'fake expenses 2',
    timestamp: fakeExpensesModel2Date.millisecondsSinceEpoch,
    amount: 60,
  );

  final fakeExpensesModel3 = ExpenseModel(
    id: '443547',
    userId: fakeUser.uid!,
    name: 'fake expenses',
    timestamp:
        DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch,
    amount: -50,
  );

  setUp(() {
    goRouter = MockGoRouter();
    expensesRepository = MockExpensesRepository();
    authRepository = MockAuthRepository();

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: ExpensesChartScreen(
        expensesRepository: expensesRepository,
        authRepository: authRepository,
      ),
    );
  }

  testWidgets(
    'test when no data displays correct message',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        false,
      )).thenAnswer(
        (_) => Stream.value(<ExpenseModel>[]),
      );

      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AspectRatio));
      final robot = ExpensesChartRobot(tester: tester);

      await tester.pump();

      expect(find.text(context.tr.yourTotalExpenses), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
      expect(
        find.text(context.tr.youHaveNotEnoughDataForChart),
        findsOneWidget,
      );
      expect(find.byType(PieChart), findsNothing);

      await robot.displayBarChart();

      expect(find.text(context.tr.yourDailyExpenses), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_rounded), findsOneWidget);
      expect(
        find.text(context.tr.youHaveNotEnoughDataForChart),
        findsOneWidget,
      );
      expect(find.byType(BarChart), findsNothing);

      await robot.displayPieChart();

      expect(find.text(context.tr.yourTotalExpenses), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
      expect(
        find.text(context.tr.youHaveNotEnoughDataForChart),
        findsOneWidget,
      );
      expect(find.byType(PieChart), findsNothing);
    },
  );

  testWidgets(
    'test two items in data are displayed correct',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        false,
      )).thenAnswer(
        (_) => Stream.value([fakeExpensesModel, fakeExpensesModel2]),
      );

      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AspectRatio));
      final robot = ExpensesChartRobot(tester: tester);

      await tester.pump();

      expect(find.byType(PieChart), findsOneWidget);

      await robot.displayBarChart();

      expect(
        find.text(context.tr.youHaveNotEnoughDataForChart),
        findsOneWidget,
      );
      expect(find.byType(BarChart), findsNothing);
    },
  );

  testWidgets(
    'test line chart is plotted with 3 items',
    (tester) async {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        false,
      )).thenAnswer(
        (_) => Stream.value([
          fakeExpensesModel3,
          fakeExpensesModel2,
          fakeExpensesModel,
        ]),
      );

      await tester.pumpWidget(createTestableWidget());

      final robot = ExpensesChartRobot(tester: tester);

      await tester.pump();

      expect(find.byType(PieChart), findsOneWidget);

      await robot.displayBarChart();

      expect(find.byType(BarChart), findsOneWidget);
    },
  );
}
