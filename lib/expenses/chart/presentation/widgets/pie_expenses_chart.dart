import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/model/expenses_pie_chart_item.dart';

class PieExpensesChart extends StatelessWidget {
  final ExpensesPieChartItem pieChartItem;
  final Color outcomeColor;
  final Color incomeColor;

  const PieExpensesChart({
    super.key,
    required this.pieChartItem,
    required this.outcomeColor,
    required this.incomeColor,
  });

  List<PieChartSectionData> _buildPieChartSectionData() {
    final chartSectionData = <PieChartSectionData>[];

    PieChartSectionData buildPieChartSectionData(double? value, Color color) {
      return PieChartSectionData(
        value: value,
        color: color,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      );
    }

    chartSectionData.add(
      buildPieChartSectionData(
        pieChartItem.income,
        incomeColor,
      ),
    );

    chartSectionData.add(
      buildPieChartSectionData(
        pieChartItem.outcome,
        outcomeColor,
      ),
    );

    return chartSectionData;
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _buildPieChartSectionData(),
        centerSpaceRadius: 50,
      ),
    );
  }
}
