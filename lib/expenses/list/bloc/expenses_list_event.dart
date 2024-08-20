part of 'expenses_list_bloc.dart';

@freezed
class ExpensesListEvent with _$ExpensesListEvent {
  const factory ExpensesListEvent.initialized() = _Initialized;

  const factory ExpensesListEvent.expensesUpdated(
    List<ExpensesListItem> expenses,
  ) = _ExpensesUpdated;

  const factory ExpensesListEvent.deleteItem(String id) = _DeleteItem;
}
