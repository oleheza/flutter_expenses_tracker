import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/add_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late AddExpensesUseCase addExpensesUseCase;
  late ExpensesRepository expensesRepository;

  setUp(() {
    expensesRepository = MockExpensesRepository();
    addExpensesUseCase = AddExpensesUseCase(expensesRepository);
  });

  test('test add expenses item is successful', () async {
    final result = await addExpensesUseCase.execute(fakeExpensesModel);

    verify(expensesRepository.addItem(fakeExpensesModel)).called(1);
    expect(result, isA<Right>());
  });

  test('test add expenses failure returns correct result', () async {
    when(expensesRepository.addItem(fakeExpensesModel)).thenThrow(Exception());

    final result = await addExpensesUseCase.execute(fakeExpensesModel);

    verify(expensesRepository.addItem(fakeExpensesModel)).called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
