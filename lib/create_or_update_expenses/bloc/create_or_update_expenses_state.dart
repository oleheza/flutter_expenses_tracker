part of 'create_or_update_expenses_bloc.dart';

@freezed
class CreateOrUpdateExpensesState with _$CreateOrUpdateExpensesState {
  const factory CreateOrUpdateExpensesState({
    Failure? failure,
    double? amount,
    @Default(false) bool expensesSaved,
    @Default('') String name,
    @Default(false) bool isValid,
    @Default(CreateOrUpdateExpensesDateHolder())
    CreateOrUpdateExpensesDateHolder dateHolder,
  }) = _CreateOrUpdateExpensesState;
}
