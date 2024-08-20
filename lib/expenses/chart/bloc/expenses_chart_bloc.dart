import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/model/expense_model.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../domain/model/expenses_bar_chart_item.dart';
import '../domain/model/expenses_pie_chart_item.dart';
import '../presentation/expenses_chart_type.dart';
import 'mixin/expenses_chart_bar_data_creator.dart';
import 'mixin/expenses_chart_grouping_helper.dart';
import 'mixin/expenses_chart_pie_data_creator.dart';

part 'expenses_chart_bloc.freezed.dart';
part 'expenses_chart_event.dart';
part 'expenses_chart_state.dart';

class ExpensesChartBloc extends Bloc<ExpensesChartEvent, ExpensesChartState>
    with
        ExpensesChartGroupingHelper,
        ExpensesChartBarDataCreator,
        ExpensesChartPieDataCreator {
  final AuthRepository authRepository;
  final ExpensesRepository expensesRepository;

  StreamSubscription<Object>? _subscription;

  ExpensesChartBloc({
    required this.expensesRepository,
    required this.authRepository,
  }) : super(const ExpensesChartState()) {
    on<ExpensesChartEvent>((event, emit) async {
      await event.when(
        initialized: () async {
          _onInitialized(emit);
        },
        updateChartData: (barChartData, pieChartData, maxValue) async {
          emit(
            state.copyWith(
              barChartData: barChartData,
              pieChartItem: pieChartData,
              maxValue: maxValue,
            ),
          );
        },
        changeChartType: (currentType) async {
          emit(
            state.copyWith(
              expensesChartType: currentType == ExpensesChartType.bar
                  ? ExpensesChartType.pie
                  : ExpensesChartType.bar,
            ),
          );
        },
      );
    });
  }

  Future<void> _onInitialized(Emitter<ExpensesChartState> emit) async {
    final currentUserId = authRepository.getCurrentUser()?.uid ?? '';

    _subscription = expensesRepository
        .expensesStream(currentUserId, ExpenseModel.fieldTimestamp, false)
        .asyncMap((expenses) => _mapChartItems(expenses))
        .listen(
          (chartData) => add(
            ExpensesChartEvent.updateChartData(
              chartData: chartData.$1,
              pieChartItem: chartData.$2,
              maxValue: chartData.$3,
            ),
          ),
        );
  }

  Future<(List<ExpensesBarChartItem>, ExpensesPieChartItem, double)>
      _mapChartItems(List<ExpenseModel> expenses) async {
    if (expenses.isEmpty) {
      return (<ExpensesBarChartItem>[], const ExpensesPieChartItem(), 0.0);
    }

    final first = expenses.first.timestamp;
    final last = expenses.last.timestamp;
    final groupedData = groupChartItems(expenses);
    final pieChartData = createPieChartData(groupedData);
    final barChartData = createBarChartData(first, last, groupedData);

    return (barChartData.$1, pieChartData, barChartData.$2);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
