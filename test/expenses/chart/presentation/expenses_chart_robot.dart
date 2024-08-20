import 'package:flutter/material.dart';

import '../../../core/presentation/base_robot.dart';

class ExpensesChartRobot extends BaseRobot {
  ExpensesChartRobot({required super.tester});

  Future<void> displayPieChart() {
    return clickWidgetWithIcon(Icons.pie_chart_rounded);
  }

  Future<void> displayBarChart() {
    return clickWidgetWithIcon(Icons.bar_chart_rounded);
  }
}
