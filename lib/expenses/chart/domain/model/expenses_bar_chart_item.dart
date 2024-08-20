import 'package:freezed_annotation/freezed_annotation.dart';

part 'expenses_bar_chart_item.freezed.dart';

@freezed
class ExpensesBarChartItem with _$ExpensesBarChartItem {
  const factory ExpensesBarChartItem({
    double? incomeSum,
    double? outcomeSum,
    required int dateInMillis,
  }) = _ExpensesBarChartItem;
}
