import 'package:flutter/widgets.dart';

import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/repository/settings_repository.dart';
import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_top_tab_bar.dart';
import '../../chart/presentation/expenses_chart_screen.dart';
import '../../list/presentation/expenses_list_screen.dart';

class ExpensesTabsScreen extends StatelessWidget {
  final tabsTags = const <String>['list', 'chart'];
  final List<Widget> tabs;

  ExpensesTabsScreen({
    super.key,
    required AuthRepository authRepository,
    required SettingsRepository settingsRepository,
    required ExpensesRepository expensesRepository,
  }) : tabs = <Widget>[
          ExpensesListScreen(
            authRepository: authRepository,
            settingsRepository: settingsRepository,
            expensesRepository: expensesRepository,
          ),
          ExpensesChartScreen(
            authRepository: authRepository,
            expensesRepository: expensesRepository,
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveTopTabBar(
      material: (_) => MaterialTopTabBarData(
        length: tabs.length,
      ),
      cupertino: (_) => CupertinoTopTabBarData(
        tabsPadding: const EdgeInsets.all(8),
        tabsTags: tabsTags,
      ),
      labels: <String>[context.tr.list, context.tr.chart],
      children: tabs,
    );
  }
}
