part of 'expenses_chart_bloc.dart';

@freezed
class ExpensesChartEvent with _$ExpensesChartEvent {

  const factory ExpensesChartEvent.initialized() = _Initialized;

  const factory ExpensesChartEvent.updateChartData({
    required List<ExpensesBarChartItem> chartData,
    required ExpensesPieChartItem pieChartItem,
    required double maxValue,
  }) = _UpdateChartData;

  const factory ExpensesChartEvent.changeChartType({
    required ExpensesChartType currentChartType,
  }) = _ChangeChartType;
}
