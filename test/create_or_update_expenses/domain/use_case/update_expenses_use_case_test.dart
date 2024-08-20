import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/update_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late UpdateExpensesUseCase updateExpensesUseCase;
  late ExpensesRepository expensesRepository;

  setUp(() {
    expensesRepository = MockExpensesRepository();
    updateExpensesUseCase = UpdateExpensesUseCase(expensesRepository);
  });

  test('test update expenses item is successful', () async {
    final result = await updateExpensesUseCase.execute(fakeExpensesModel);

    verify(expensesRepository.updateItem(fakeExpensesModel)).called(1);
    expect(result, isA<Right>());
  });

  test('test update expenses item failure returns correct result', () async {
    when(expensesRepository.updateItem(fakeExpensesModel))
        .thenThrow(Exception());

    final result = await updateExpensesUseCase.execute(fakeExpensesModel);

    verify(expensesRepository.updateItem(fakeExpensesModel)).called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
