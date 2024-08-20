import 'dart:math';

import '../../../../core/domain/extensions/date_time_extensions.dart';
import '../../domain/model/expenses_bar_chart_item.dart';

mixin ExpensesChartBarDataCreator {
  (List<ExpensesBarChartItem>, double) createBarChartData(
    int firstItemTime,
    int lastItemTime,
    Map<DateTime, ExpensesBarChartItem> groupedData,
  ) {
    final startDateTime =
        DateTime.fromMillisecondsSinceEpoch(firstItemTime).toEndOfDay();
    final lastDateTime =
        DateTime.fromMillisecondsSinceEpoch(lastItemTime).toEndOfDay();

    DateTime currentDateTime = startDateTime;
    double maxValue = 0;

    final List<ExpensesBarChartItem> result = <ExpensesBarChartItem>[];

    while (!currentDateTime.isAfter(lastDateTime)) {
      final item = groupedData[currentDateTime];
      if (item != null) {
        final maxSumValue = max(item.incomeSum ?? 0, item.outcomeSum ?? 0);
        if (maxSumValue > maxValue) {
          maxValue = maxSumValue;
        }
        result.add(item);
      } else {
        result.add(ExpensesBarChartItem(
          dateInMillis: currentDateTime.millisecondsSinceEpoch,
        ));
      }

      currentDateTime =
          currentDateTime.add(const Duration(seconds: 1)).toEndOfDay();
    }

    return (result, maxValue);
  }
}
