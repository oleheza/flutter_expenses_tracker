import '../../domain/model/expenses_bar_chart_item.dart';
import '../../domain/model/expenses_pie_chart_item.dart';

mixin ExpensesChartPieDataCreator {
  ExpensesPieChartItem createPieChartData(
    Map<DateTime, ExpensesBarChartItem> groupedData,
  ) {
    double totalIncome = 0, totalOutcome = 0;
    for (var element in groupedData.values) {
      totalOutcome += element.outcomeSum ?? 0;
      totalIncome += element.incomeSum ?? 0;
    }

    return ExpensesPieChartItem(
      income: totalIncome,
      outcome: totalOutcome,
    );
  }
}
