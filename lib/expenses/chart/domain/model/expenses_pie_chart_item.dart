import 'package:freezed_annotation/freezed_annotation.dart';

part 'expenses_pie_chart_item.freezed.dart';

@freezed
class ExpensesPieChartItem with _$ExpensesPieChartItem {
  const factory ExpensesPieChartItem({
    @Default(0) double income,
    @Default(0) double? outcome,
  }) = _ExpensesPieChartItem;
}
