part of 'create_or_update_expenses_bloc.dart';

@freezed
class CreateOrUpdateExpensesEvent with _$CreateOrUpdateExpensesEvent {
  const factory CreateOrUpdateExpensesEvent.initialized() = _Initialized;

  const factory CreateOrUpdateExpensesEvent.nameUpdated({
    required String name,
  }) = _NameUpdated;

  const factory CreateOrUpdateExpensesEvent.amountUpdated({
    required String amount,
  }) = _AmountUpdated;

  const factory CreateOrUpdateExpensesEvent.dateUpdated({
    required DateTime date,
  }) = _DateUpdated;

  const factory CreateOrUpdateExpensesEvent.createOrUpdateExpenses() =
      _CreateOrUpdateExpenses;
}
