import 'package:expenses_tracker/core/domain/exceptions/expenses_not_found_exception.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/get_expenses_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late GetExpensesByIdUseCase getExpensesByIdUseCase;
  late ExpensesRepository expensesRepository;

  final fakeUserId = fakeUser.uid!;
  final fakeExpensesItemId = fakeExpensesModel.id!;

  final useCaseParam = GetExpensesByIdParams(
    userId: fakeUserId,
    expensesId: fakeExpensesItemId,
  );

  setUp(() {
    expensesRepository = MockExpensesRepository();
    getExpensesByIdUseCase = GetExpensesByIdUseCase(expensesRepository);
  });

  test('get expenses item by id returns correct value', () async {
    when(expensesRepository.getItemById(fakeUserId, fakeExpensesItemId))
        .thenAnswer((_) async => fakeExpensesModel);

    final result = await getExpensesByIdUseCase.execute(useCaseParam);

    verify(expensesRepository.getItemById(fakeUserId, fakeExpensesItemId))
        .called(1);

    expect(result.getRight().toNullable(), fakeExpensesModel);
  });

  test('get expenses item by ide returns failure when not found', () async {
    when(expensesRepository.getItemById(fakeUserId, fakeExpensesItemId))
        .thenThrow(const ExpensesNotFoundException());

    final result = await getExpensesByIdUseCase.execute(useCaseParam);

    verify(expensesRepository.getItemById(fakeUserId, fakeExpensesItemId))
        .called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
