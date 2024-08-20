import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/extensions/date_time_extensions.dart';
import '../../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../../domain/model/expenses_bar_chart_item.dart';

class BarExpensesChart extends StatelessWidget {
  final List<ExpensesBarChartItem> chartData;
  final double maxValue;
  final Color incomeBarColor;
  final Color outcomeBarColor;

  static const double _sideTitleReservedSize = 40;
  static const double _defaultBarWidth = 75;

  const BarExpensesChart({
    super.key,
    required this.chartData,
    required this.incomeBarColor,
    required this.outcomeBarColor,
    required this.maxValue,
  });

  BarChartGroupData _makeGroupData(int index, ExpensesBarChartItem chartItem) {
    return BarChartGroupData(
      x: index,
      barsSpace: 4,
      barRods: <BarChartRodData>[
        BarChartRodData(
          toY: chartItem.incomeSum ?? 0,
          color: incomeBarColor,
        ),
        BarChartRodData(
          toY: chartItem.outcomeSum ?? 0,
          color: outcomeBarColor,
        ),
      ],
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta titleMeta) {
    final date = chartData[value.toInt()].dateInMillis;
    final formattedDate =
        DateTime.fromMillisecondsSinceEpoch(date).formatToShortDate();
    return AdaptiveText(
      text: formattedDate,
      textStyle: const TextStyle(fontSize: 10),
    );
  }

  Widget _buildSideBarTitle(double value, TitleMeta titleMeta) {
    return AdaptiveText(
      text: titleMeta.formattedValue,
      textStyle: const TextStyle(fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chart = Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: BarChart(
        BarChartData(
          maxY: maxValue + maxValue / 5,
          minY: 0,
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildSideBarTitle,
                reservedSize: _sideTitleReservedSize,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildSideBarTitle,
                reservedSize: _sideTitleReservedSize,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildBottomTitle,
              ),
            ),
          ),
          barGroups: chartData
              .mapWithIndex((item, index) => _makeGroupData(index, item))
              .toList(),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartData.length * _defaultBarWidth,
        child: chart,
      ),
    );
  }
}
