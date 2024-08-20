import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain/repository/auth_repository.dart';
import '../../core/domain/repository/settings_repository.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widgets/adaptive/adaptive_app_bar.dart';
import '../../core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import '../bloc/create_or_update_expenses_bloc.dart';
import '../domain/use_case/add_expenses_use_case.dart';
import '../domain/use_case/get_expenses_by_id_use_case.dart';
import '../domain/use_case/update_expenses_use_case.dart';
import 'create_or_update_expenses_content.dart';

class CreateOrUpdateExpensesScreen extends StatelessWidget {
  static const String route = '/create-or-update-expenses';
  static const String screenName = 'create-or-update-expenses';

  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;
  final AddExpensesUseCase addExpensesUseCase;
  final GetExpensesByIdUseCase getExpensesByIdUseCase;
  final UpdateExpensesUseCase updateExpensesUseCase;

  final String? originalExpensesId;

  const CreateOrUpdateExpensesScreen({
    super.key,
    this.originalExpensesId,
    required this.authRepository,
    required this.settingsRepository,
    required this.addExpensesUseCase,
    required this.getExpensesByIdUseCase,
    required this.updateExpensesUseCase,
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(
      originalExpensesId != null
          ? context.tr.editExpenses
          : context.tr.addExpenses,
    );

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        material: (_) => MaterialAppBarData(
          title: title,
        ),
        cupertino: (_) => CupertinoAppBarData(
          middle: title,
        ),
      ),
      child: SafeArea(
        child: BlocProvider(
          create: (context) => CreateOrUpdateExpensesBloc(
            authRepository: authRepository,
            settingsRepository: settingsRepository,
            addExpensesUseCase: addExpensesUseCase,
            getExpensesByIdUseCase: getExpensesByIdUseCase,
            updateExpensesUseCase: updateExpensesUseCase,
            originalExpensesId: originalExpensesId,
          )..add(const CreateOrUpdateExpensesEvent.initialized()),
          child: AddExpensesContent(
            isEdit: originalExpensesId != null,
          ),
        ),
      ),
    );
  }
}
