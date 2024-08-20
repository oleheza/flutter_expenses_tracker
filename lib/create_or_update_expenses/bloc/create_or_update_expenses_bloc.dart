import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/config/app_language.dart';
import '../../core/domain/failure/failure.dart';
import '../../core/domain/model/expense_model.dart';
import '../../core/domain/repository/auth_repository.dart';
import '../../core/domain/repository/settings_repository.dart';
import '../domain/use_case/add_expenses_use_case.dart';
import '../domain/use_case/get_expenses_by_id_use_case.dart';
import '../domain/use_case/update_expenses_use_case.dart';
import 'create_or_update_expenses_date_holder.dart';

part 'create_or_update_expenses_bloc.freezed.dart';
part 'create_or_update_expenses_event.dart';
part 'create_or_update_expenses_state.dart';

class CreateOrUpdateExpensesBloc
    extends Bloc<CreateOrUpdateExpensesEvent, CreateOrUpdateExpensesState> {
  final SettingsRepository settingsRepository;
  final AddExpensesUseCase addExpensesUseCase;
  final GetExpensesByIdUseCase getExpensesByIdUseCase;
  final UpdateExpensesUseCase updateExpensesUseCase;

  // shall be not null when the user updates item
  final String? originalExpensesId;
  final bool isEdit;

  late String currentUserId;

  CreateOrUpdateExpensesBloc({
    required AuthRepository authRepository,
    required this.settingsRepository,
    required this.addExpensesUseCase,
    required this.getExpensesByIdUseCase,
    required this.updateExpensesUseCase,
    this.originalExpensesId,
  })  : isEdit = originalExpensesId != null,
        super(const CreateOrUpdateExpensesState()) {
    currentUserId = authRepository.getCurrentUser()?.uid ?? '';
    on<CreateOrUpdateExpensesEvent>((event, emit) async {
      await event.when(
        initialized: () async => _onInitialized(emit),
        nameUpdated: (name) async => _onNameUpdated(emit, name),
        amountUpdated: (amount) async => _onAmountUpdated(emit, amount),
        dateUpdated: (date) async => _onDateUpdated(emit, date),
        createOrUpdateExpenses: () async => _onCreateOrSaveExpenses(emit),
      );
    });
  }

  Future<void> _onInitialized(Emitter<CreateOrUpdateExpensesState> emit) async {
    emit(
      state.copyWith(
        dateHolder: CreateOrUpdateExpensesDateHolder(
          language: getAppLanguageByString(
            settingsRepository.getCurrentLocale(),
          ),
        ),
      ),
    );
    if (isEdit) {
      await _loadInitialExpensesData(emit, originalExpensesId!);
    }
  }

  void _onNameUpdated(Emitter<CreateOrUpdateExpensesState> emit, String name) {
    emit(
      state.copyWith(
        name: name,
        isValid: _isValid(name, state.amount, state.dateHolder.date),
      ),
    );
  }

  void _onAmountUpdated(
      Emitter<CreateOrUpdateExpensesState> emit, String amount) {
    final parsedAmount = double.tryParse(amount);
    emit(
      state.copyWith(
        amount: parsedAmount,
        isValid: _isValid(state.name, parsedAmount, state.dateHolder.date),
      ),
    );
  }

  void _onDateUpdated(
      Emitter<CreateOrUpdateExpensesState> emit, DateTime date) {
    emit(
      state.copyWith(
        dateHolder: state.dateHolder.copyWith(date: date),
        isValid: _isValid(state.name, state.amount, date),
      ),
    );
  }

  Future<void> _onCreateOrSaveExpenses(
    Emitter<CreateOrUpdateExpensesState> emit,
  ) async {
    final future = isEdit ? _updateExpenses() : _createExpenses();
    final result = await future;

    result.fold(
      (failure) => null,
      (success) => emit(state.copyWith(expensesSaved: true)),
    );
  }

  Future<Either<Failure, void>> _createExpenses() {
    final expenseModel = ExpenseModel(
      userId: currentUserId,
      name: state.name,
      amount: state.amount!,
      timestamp: state.dateHolder.date!.millisecondsSinceEpoch,
    );

    return addExpensesUseCase.execute(expenseModel);
  }

  Future<Either<Failure, void>> _updateExpenses() async {
    final expenseModel = ExpenseModel(
      id: originalExpensesId,
      userId: currentUserId,
      name: state.name,
      amount: state.amount!,
      timestamp: state.dateHolder.date!.millisecondsSinceEpoch,
    );

    return updateExpensesUseCase.execute(expenseModel);
  }

  Future<void> _loadInitialExpensesData(
    Emitter<CreateOrUpdateExpensesState> emit,
    String expensesId,
  ) async {
    final params = GetExpensesByIdParams(
      userId: currentUserId,
      expensesId: expensesId,
    );

    final result = await getExpensesByIdUseCase.execute(params);
    final expensesModel = result.toNullable();
    if (expensesModel != null) {
      emit(
        state.copyWith(
          amount: expensesModel.amount,
          dateHolder: state.dateHolder.copyWith(
            date: DateTime.fromMillisecondsSinceEpoch(expensesModel.timestamp),
          ),
          name: expensesModel.name,
          isValid: true,
        ),
      );
    }
  }

  bool _isValid(String name, double? amount, DateTime? date) {
    return name.isNotEmpty && amount != null && date != null;
  }
}
