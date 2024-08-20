import '../../../../app/config/app_language.dart';
import '../../../../core/domain/model/expense_model.dart';

sealed class ExpensesListItem {}

class ExpensesDateListItem implements ExpensesListItem {
  final int dateInMillis;
  final AppLanguage language;

  ExpensesDateListItem({
    required this.dateInMillis,
    required this.language,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensesDateListItem &&
          runtimeType == other.runtimeType &&
          dateInMillis == other.dateInMillis &&
          language == other.language;

  @override
  int get hashCode => dateInMillis.hashCode ^ language.hashCode;
}

class ExpensesModelListItem implements ExpensesListItem {
  final ExpenseModel expenseModel;

  ExpensesModelListItem({required this.expenseModel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensesModelListItem &&
          runtimeType == other.runtimeType &&
          expenseModel == other.expenseModel;

  @override
  int get hashCode => expenseModel.hashCode;
}
