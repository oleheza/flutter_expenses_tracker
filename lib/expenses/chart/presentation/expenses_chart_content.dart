import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_icon.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_progress_indicator.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../bloc/expenses_chart_bloc.dart';
import '../domain/model/expenses_bar_chart_item.dart';
import '../domain/model/expenses_pie_chart_item.dart';
import 'expenses_chart_type.dart';
import 'widgets/bar_expenses_chart.dart';
import 'widgets/pie_expenses_chart.dart';

class ExpensesChartContent extends StatelessWidget {
  static const double _chartHeight = 300;

  const ExpensesChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BlocBuilder<ExpensesChartBloc, ExpensesChartState>(
              builder: (context, chartData) {
                final barChartData = chartData.barChartData;
                final pieChartItem = chartData.pieChartItem;
                if (barChartData == null || pieChartItem == null) {
                  return const Center(
                    child: AdaptiveProgressIndicator(),
                  );
                }
                final chart = switch (chartData.expensesChartType) {
                  ExpensesChartType.bar => _ExpensesBarChart(
                      chartData: barChartData,
                      maxValue: chartData.maxValue,
                      height: _chartHeight,
                    ),
                  ExpensesChartType.pie => _ExpensesPieChart(
                      pieChartData: pieChartItem,
                      height: _chartHeight,
                    ),
                };
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _ExpensesChartTitle(
                      chartType: chartData.expensesChartType,
                      onChangeChartType: () {
                        context.read<ExpensesChartBloc>().add(
                              ExpensesChartEvent.changeChartType(
                                currentChartType: chartData.expensesChartType,
                              ),
                            );
                      },
                    ),
                    chart,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesBarChart extends StatelessWidget {
  final List<ExpensesBarChartItem> chartData;
  final double maxValue;
  final double? height;

  const _ExpensesBarChart({
    super.key,
    required this.chartData,
    required this.maxValue,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return chartData.length >= 2
        ? SizedBox(
            height: height,
            child: BarExpensesChart(
              chartData: chartData,
              maxValue: maxValue,
              incomeBarColor: AppColors.incomeColor,
              outcomeBarColor: AppColors.outcomeColor,
            ),
          )
        : const _NotEnoughDataWidget();
  }
}

class _ExpensesPieChart extends StatelessWidget {
  final ExpensesPieChartItem pieChartData;
  final double? height;

  const _ExpensesPieChart({
    super.key,
    required this.pieChartData,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return pieChartData.income != 0 || pieChartData.outcome != 0
        ? SizedBox(
            height: height,
            child: PieExpensesChart(
              incomeColor: AppColors.incomeColor,
              outcomeColor: AppColors.outcomeColor,
              pieChartItem: pieChartData,
            ),
          )
        : const _NotEnoughDataWidget();
  }
}

class _ExpensesChartTitle extends StatelessWidget {
  final ExpensesChartType chartType;
  final VoidCallback onChangeChartType;

  const _ExpensesChartTitle({
    super.key,
    required this.chartType,
    required this.onChangeChartType,
  });

  @override
  Widget build(BuildContext context) {
    final (String, IconData, IconData) data = switch (chartType) {
      ExpensesChartType.bar => (
          context.tr.yourDailyExpenses,
          Icons.pie_chart_rounded,
          CupertinoIcons.chart_pie_fill,
        ),
      ExpensesChartType.pie => (
          context.tr.yourTotalExpenses,
          Icons.bar_chart_rounded,
          CupertinoIcons.chart_bar_alt_fill,
        ),
    };

    return Row(
      children: <Widget>[
        Expanded(child: AdaptiveText(text: data.$1)),
        IconButton(
          onPressed: onChangeChartType,
          icon: AdaptiveIcon(
            material: (_) => MaterialAdaptiveIconData(
              icon: data.$2,
              color: context.materialTheme.colorScheme.primary,
            ),
            cupertino: (_) => CupertinoAdaptiveIconData(
              icon: data.$3,
              color: context.cupertinoTheme.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}

class _NotEnoughDataWidget extends StatelessWidget {
  const _NotEnoughDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      alignment: Alignment.bottomCenter,
      child: AdaptiveText(
        text: context.tr.youHaveNotEnoughDataForChart,
      ),
    );
  }
}
