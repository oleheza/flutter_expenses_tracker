import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/repository/settings_repository.dart';
import '../bloc/expenses_list_bloc.dart';
import 'expenses_list_content.dart';

class ExpensesListScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;
  final ExpensesRepository expensesRepository;

  const ExpensesListScreen({
    super.key,
    required this.authRepository,
    required this.settingsRepository,
    required this.expensesRepository,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ExpensesListBloc(
          authRepository: authRepository,
          settingsRepository: settingsRepository,
          expensesRepository: expensesRepository,
        )..add(const ExpensesListEvent.initialized()),
        child: const ExpensesListContent(),
      ),
    );
  }
}
