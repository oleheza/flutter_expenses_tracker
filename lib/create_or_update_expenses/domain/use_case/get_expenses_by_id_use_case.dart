import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/expense_model.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class GetExpensesByIdUseCase
    implements FutureUseCase<GetExpensesByIdParams, ExpenseModel?> {
  final ExpensesRepository _expensesRepository;

  GetExpensesByIdUseCase(this._expensesRepository);

  @override
  Future<Either<Failure, ExpenseModel?>> execute(
    GetExpensesByIdParams param,
  ) async {
    try {
      final item = await _expensesRepository.getItemById(
        param.userId,
        param.expensesId,
      );

      return Right(item);
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}

class GetExpensesByIdParams {
  final String userId;
  final String expensesId;

  GetExpensesByIdParams({
    required this.userId,
    required this.expensesId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetExpensesByIdParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          expensesId == other.expensesId;

  @override
  int get hashCode => Object.hash(userId, expensesId);
}
