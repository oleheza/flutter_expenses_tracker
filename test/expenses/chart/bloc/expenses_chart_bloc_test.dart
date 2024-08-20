import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/core/domain/extensions/date_time_extensions.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/expenses/chart/bloc/expenses_chart_bloc.dart';
import 'package:expenses_tracker/expenses/chart/domain/model/expenses_bar_chart_item.dart';
import 'package:expenses_tracker/expenses/chart/domain/model/expenses_pie_chart_item.dart';
import 'package:expenses_tracker/expenses/chart/presentation/expenses_chart_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late ExpensesChartBloc expensesChartBloc;
  late ExpensesRepository expensesRepository;
  late AuthRepository authRepository;

  final now = DateTime.now();
  final nowInMillis = now.millisecondsSinceEpoch;
  final twoDaysAgoInMillis =
      now.subtract(const Duration(days: 2)).millisecondsSinceEpoch;

  final fakeExpensesModel1 = ExpenseModel(
    id: '443545',
    userId: fakeUser.uid!,
    name: 'fake expenses',
    timestamp: twoDaysAgoInMillis,
    amount: -100,
  );

  final fakeExpensesModel2 = ExpenseModel(
    id: '443546',
    userId: fakeUser.uid!,
    name: 'fake expenses',
    timestamp: nowInMillis,
    amount: 60,
  );

  final fakeExpensesModel3 = ExpenseModel(
    id: '443547',
    userId: fakeUser.uid!,
    name: 'fake expenses',
    timestamp: nowInMillis,
    amount: -50,
  );

  setUp(() {
    expensesRepository = MockExpensesRepository();
    authRepository = MockAuthRepository();

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);

    expensesChartBloc = ExpensesChartBloc(
      expensesRepository: expensesRepository,
      authRepository: authRepository,
    );
  });

  blocTest(
    'test switching chart type provides correct state',
    build: () => expensesChartBloc,
    act: (bloc) {
      bloc.add(const ExpensesChartEvent.changeChartType(
        currentChartType: ExpensesChartType.pie,
      ));

      bloc.add(const ExpensesChartEvent.changeChartType(
        currentChartType: ExpensesChartType.bar,
      ));
    },
    expect: () {
      return <ExpensesChartState>[
        const ExpensesChartState(expensesChartType: ExpensesChartType.bar),
        const ExpensesChartState(expensesChartType: ExpensesChartType.pie),
      ];
    },
    tearDown: () => expensesChartBloc.close(),
  );

  blocTest(
    'test empty chart data provides correct state',
    build: () => expensesChartBloc,
    setUp: () {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        false,
      )).thenAnswer((_) => Stream.value([]));
    },
    act: (bloc) {
      bloc.add(const ExpensesChartEvent.initialized());
    },
    expect: () {
      return <ExpensesChartState>[
        const ExpensesChartState(
          barChartData: <ExpensesBarChartItem>[],
          pieChartItem: ExpensesPieChartItem(income: 0.0, outcome: 0.0),
          maxValue: 0,
        )
      ];
    },
    tearDown: () => expensesChartBloc.close(),
  );

  blocTest(
    'test chart data provides correct state',
    build: () => expensesChartBloc,
    setUp: () {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        false,
      )).thenAnswer((_) => Stream.value([
            fakeExpensesModel1,
            fakeExpensesModel2,
            fakeExpensesModel3,
          ]));
    },
    act: (bloc) {
      bloc.add(const ExpensesChartEvent.initialized());
    },
    expect: () {
      return <ExpensesChartState>[
        ExpensesChartState(
          barChartData: <ExpensesBarChartItem>[
            ExpensesBarChartItem(
              dateInMillis: twoDaysAgoInMillis,
              incomeSum: 0,
              outcomeSum: 100,
            ),
            ExpensesBarChartItem(
              dateInMillis: DateTime.fromMillisecondsSinceEpoch(
                twoDaysAgoInMillis + const Duration(days: 1).inMilliseconds,
              ).toEndOfDay().millisecondsSinceEpoch,
            ),
            ExpensesBarChartItem(
              dateInMillis: nowInMillis,
              incomeSum: 60,
              outcomeSum: 50,
            )
          ],
          pieChartItem: const ExpensesPieChartItem(income: 60, outcome: 150),
          maxValue: 100,
        )
      ];
    },
    tearDown: () => expensesChartBloc.close(),
  );
}
