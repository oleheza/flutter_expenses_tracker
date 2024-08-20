import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/expense_model.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class AddExpensesUseCase implements FutureUseCase<ExpenseModel, void> {
  final ExpensesRepository _expensesRepository;

  AddExpensesUseCase(this._expensesRepository);

  @override
  Future<Either<Failure, void>> execute(ExpenseModel param) async {
    try {
      _expensesRepository.addItem(param);

      return const Right(null);
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}
