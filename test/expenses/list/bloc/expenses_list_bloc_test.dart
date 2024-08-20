import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/expenses/list/bloc/expenses_list_bloc.dart';
import 'package:expenses_tracker/expenses/list/domain/model/expenses_list_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late ExpensesListBloc expensesListBloc;
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late ExpensesRepository expensesRepository;

  final fakeExpensesModel2Date =
      DateTime.now().subtract(const Duration(days: 2));

  final fakeExpensesModel2 = ExpenseModel(
    id: '443546',
    userId: fakeUser.uid!,
    name: 'fake expenses 2',
    timestamp: fakeExpensesModel2Date.millisecondsSinceEpoch,
    amount: 60,
  );

  setUp(() {
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    expensesRepository = MockExpensesRepository();

    when(settingsRepository.getCurrentLocale())
        .thenReturn(AppLanguage.english.code);

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);

    expensesListBloc = ExpensesListBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
      expensesRepository: expensesRepository,
    );
  });

  blocTest(
    'test expenses list provide correct state',
    build: () => expensesListBloc,
    setUp: () {
      when(expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      )).thenAnswer((_) => Stream.value([
            fakeExpensesModel2,
            fakeExpensesModel,
          ]));
    },
    act: (bloc) => bloc.add(const ExpensesListEvent.initialized()),
    expect: () {
      return <ExpensesListState>[
        ExpensesListState(
          expenses: [
            ExpensesDateListItem(
              dateInMillis: fakeExpensesModel2Date.millisecondsSinceEpoch,
              language: AppLanguage.english,
            ),
            ExpensesModelListItem(expenseModel: fakeExpensesModel2),
            ExpensesDateListItem(
              dateInMillis: fakeExpensesModel.timestamp,
              language: AppLanguage.english,
            ),
            ExpensesModelListItem(expenseModel: fakeExpensesModel),
          ],
        ),
      ];
    },
    tearDown: () => expensesListBloc.close(),
  );

  blocTest(
    'test expenses list delete item is correct',
    build: () => expensesListBloc,
    act: (bloc) =>
        bloc.add(ExpensesListEvent.deleteItem(fakeExpensesModel.id!)),
    verify: (_) {
      verify(expensesRepository.deleteItem(
        fakeUser.uid!,
        fakeExpensesModel.id!,
      )).called(1);
    },
    tearDown: () => expensesListBloc.close(),
  );
}
