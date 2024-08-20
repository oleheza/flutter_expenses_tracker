part of 'expenses_chart_bloc.dart';

@freezed
class ExpensesChartState with _$ExpensesChartState {
  const factory ExpensesChartState({
    List<ExpensesBarChartItem>? barChartData,
    ExpensesPieChartItem? pieChartItem,
    @Default(0) double maxValue,
    @Default(ExpensesChartType.pie) ExpensesChartType expensesChartType,
  }) = _ExpensesChartState;
}
