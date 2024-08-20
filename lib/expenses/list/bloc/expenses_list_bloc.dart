import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/config/app_language.dart';
import '../../../core/domain/extensions/date_time_extensions.dart';
import '../../../core/domain/model/expense_model.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/repository/settings_repository.dart';
import '../domain/model/expenses_list_item.dart';

part 'expenses_list_bloc.freezed.dart';
part 'expenses_list_event.dart';
part 'expenses_list_state.dart';

class ExpensesListBloc extends Bloc<ExpensesListEvent, ExpensesListState> {
  final ExpensesRepository expensesRepository;
  final String _currentUserId;
  final AppLanguage _language;

  StreamSubscription<List<ExpensesListItem>>? _expensesSubscription;

  ExpensesListBloc({
    required AuthRepository authRepository,
    required SettingsRepository settingsRepository,
    required this.expensesRepository,
  })  : _currentUserId = authRepository.getCurrentUser()?.uid ?? '',
        _language =
            getAppLanguageByString(settingsRepository.getCurrentLocale()),
        super(const ExpensesListState()) {
    on<ExpensesListEvent>(
      (event, emit) {
        event.when(
            initialized: () => _onInitialized(emit),
            expensesUpdated: (expenses) => emit(
                  state.copyWith(expenses: expenses)
                ),
            deleteItem: (id) => _onDeleteItem(id));
      },
    );
  }

  @override
  Future<void> close() async {
    _unsubscribeFromListChanges();
    return super.close();
  }

  Future<void> _onInitialized(Emitter<ExpensesListState> emit) async {
    _subscribeToListChanges();
  }

  void _subscribeToListChanges() {
    _expensesSubscription = expensesRepository
        .expensesStream(_currentUserId, ExpenseModel.fieldTimestamp, true)
        .asyncMap((event) => _mapToListItems(event))
        .listen((event) => add(ExpensesListEvent.expensesUpdated(event)));
  }

  void _onDeleteItem(String id) async {
    expensesRepository.deleteItem(_currentUserId, id);
  }

  void _unsubscribeFromListChanges() {
    _expensesSubscription?.cancel();
  }

  Future<List<ExpensesListItem>> _mapToListItems(
    List<ExpenseModel> expenses,
  ) async {
    List<ExpensesListItem> groupedItems = <ExpensesListItem>[];
    DateTime? currentDate;

    for (var item in expenses) {
      final expenseDate = DateTime.fromMillisecondsSinceEpoch(
        item.timestamp,
      );
      if (currentDate == null || !expenseDate.isSameDate(currentDate)) {
        currentDate = expenseDate;
        groupedItems.add(
          ExpensesDateListItem(
            dateInMillis: expenseDate.millisecondsSinceEpoch,
            language: _language,
          ),
        );
      }
      groupedItems.add(ExpensesModelListItem(expenseModel: item));
    }

    return groupedItems;
  }
}
