part of 'expenses_list_bloc.dart';

@freezed
class ExpensesListState with _$ExpensesListState {
  const factory ExpensesListState({
    List<ExpensesListItem>? expenses,
  }) = _ExpensesListState;
}
