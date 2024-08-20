import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../bloc/expenses_chart_bloc.dart';
import 'expenses_chart_content.dart';

class ExpensesChartScreen extends StatelessWidget {
  final ExpensesRepository expensesRepository;
  final AuthRepository authRepository;

  const ExpensesChartScreen({
    super.key,
    required this.expensesRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesChartBloc(
        expensesRepository: expensesRepository,
        authRepository: authRepository,
      )..add(const ExpensesChartEvent.initialized()),
      child: const ExpensesChartContent(),
    );
  }
}
