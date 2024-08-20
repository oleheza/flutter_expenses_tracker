import '../../../../core/domain/extensions/date_time_extensions.dart';
import '../../../../core/domain/model/expense_model.dart';
import '../../domain/model/expenses_bar_chart_item.dart';

mixin ExpensesChartGroupingHelper {
  Map<DateTime, ExpensesBarChartItem> groupChartItems(
      List<ExpenseModel> expenses) {
    final result = <DateTime, ExpensesBarChartItem>{};

    double incomeSum = 0, outcomeSum = 0;
    DateTime currentDateTime =
        DateTime.fromMillisecondsSinceEpoch(expenses.first.timestamp);

    for (var i = 0; i < expenses.length; i++) {
      final item = expenses[i];
      final itemDateTime = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
      if (!itemDateTime.isSameDate(currentDateTime)) {
        result[currentDateTime.toEndOfDay()] = ExpensesBarChartItem(
          incomeSum: incomeSum,
          outcomeSum: outcomeSum,
          dateInMillis: currentDateTime.millisecondsSinceEpoch,
        );
        incomeSum = 0;
        outcomeSum = 0;
        currentDateTime = itemDateTime;
      }
      final value = item.amount;
      if (value > 0) {
        incomeSum += value;
      } else if (value < 0) {
        outcomeSum += -value;
      }
      if (i == expenses.length - 1) {
        result[itemDateTime.toEndOfDay()] = ExpensesBarChartItem(
          incomeSum: incomeSum,
          outcomeSum: outcomeSum,
          dateInMillis: itemDateTime.millisecondsSinceEpoch,
        );
      }
    }

    return result;
  }
}
