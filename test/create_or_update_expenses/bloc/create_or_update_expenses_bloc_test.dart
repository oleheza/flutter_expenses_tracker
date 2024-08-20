import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:expenses_tracker/create_or_update_expenses/bloc/create_or_update_expenses_bloc.dart';
import 'package:expenses_tracker/create_or_update_expenses/bloc/create_or_update_expenses_date_holder.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/add_expenses_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/get_expenses_by_id_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/update_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import '../../mocks/repository_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';

void main() {
  late CreateOrUpdateExpensesBloc createExpensesBloc;
  late CreateOrUpdateExpensesBloc updateExpensesBloc;
  late AuthRepository authRepository;
  late SettingsRepository settingsRepository;
  late AddExpensesUseCase addExpensesUseCase;
  late UpdateExpensesUseCase updateExpensesUseCase;
  late GetExpensesByIdUseCase getExpensesByIdUseCase;

  final getExpensesItemByIdUseCaseParams = GetExpensesByIdParams(
    userId: fakeUser.uid!,
    expensesId: fakeExpensesModel.id!,
  );

  final fakeSelectedDate =
      DateTime.fromMillisecondsSinceEpoch(fakeExpensesModel.timestamp);
  final fakeSelectedName = fakeExpensesModel.name;
  final double fakeSelectedAmount = fakeExpensesModel.amount;



  setUp(() {
    provideDummy<Either<Failure, ExpenseModel?>>(Right(fakeExpensesModel));
    provideDummy<Either<Failure, void>>(const Right(null));

    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    addExpensesUseCase = MockAddExpensesUseCase();
    updateExpensesUseCase = MockUpdateExpensesUseCase();
    getExpensesByIdUseCase = MockGetExpensesByIdUseCase();
    createExpensesBloc = CreateOrUpdateExpensesBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
      addExpensesUseCase: addExpensesUseCase,
      getExpensesByIdUseCase: getExpensesByIdUseCase,
      updateExpensesUseCase: updateExpensesUseCase,
    );
    updateExpensesBloc = CreateOrUpdateExpensesBloc(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
      addExpensesUseCase: addExpensesUseCase,
      getExpensesByIdUseCase: getExpensesByIdUseCase,
      updateExpensesUseCase: updateExpensesUseCase,
      originalExpensesId: fakeExpensesModel.id!,
    );

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
  });

  blocTest(
    'test create expenses bloc initialization is correct',
    setUp: () {
      when(settingsRepository.getCurrentLocale())
          .thenReturn(AppLanguage.ukrainian.code);
    },
    build: () => createExpensesBloc,
    act: (bloc) {
      bloc.add(const CreateOrUpdateExpensesEvent.initialized());
    },
    expect: () {
      return <CreateOrUpdateExpensesState>[
        const CreateOrUpdateExpensesState(
          dateHolder: CreateOrUpdateExpensesDateHolder(
            language: AppLanguage.ukrainian,
          ),
        )
      ];
    },
    verify: (bloc) {
      verifyNever(
          getExpensesByIdUseCase.execute(getExpensesItemByIdUseCaseParams));
    },
    tearDown: () => createExpensesBloc.close(),
  );

  blocTest(
    'test update expenses bloc initialization is correct',
    setUp: () {
      when(settingsRepository.getCurrentLocale())
          .thenReturn(AppLanguage.ukrainian.code);
      when(getExpensesByIdUseCase.execute(getExpensesItemByIdUseCaseParams))
          .thenAnswer((_) async => Right(fakeExpensesModel));
    },
    build: () => updateExpensesBloc,
    act: (bloc) {
      bloc.add(const CreateOrUpdateExpensesEvent.initialized());
    },
    expect: () {
      return <CreateOrUpdateExpensesState>[
        const CreateOrUpdateExpensesState(
          dateHolder: CreateOrUpdateExpensesDateHolder(
            language: AppLanguage.ukrainian,
          ),
        ),
        CreateOrUpdateExpensesState(
          dateHolder: CreateOrUpdateExpensesDateHolder(
            language: AppLanguage.ukrainian,
            date: DateTime.fromMillisecondsSinceEpoch(
              fakeExpensesModel.timestamp,
            ),
          ),
          name: fakeExpensesModel.name,
          amount: fakeExpensesModel.amount,
          isValid: true,
        )
      ];
    },
    tearDown: () => updateExpensesBloc.close(),
  );

  blocTest(
    'test input updates provide correct state',
    build: () => createExpensesBloc,
    act: (bloc) {
      bloc.add(CreateOrUpdateExpensesEvent.nameUpdated(
        name: fakeSelectedName,
      ));
      bloc.add(CreateOrUpdateExpensesEvent.amountUpdated(
        amount: fakeSelectedAmount.toString(),
      ));
      bloc.add(CreateOrUpdateExpensesEvent.dateUpdated(date: fakeSelectedDate));
    },
    expect: () {
      return <CreateOrUpdateExpensesState>[
        CreateOrUpdateExpensesState(name: fakeSelectedName),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
        ),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
          isValid: true,
          dateHolder: CreateOrUpdateExpensesDateHolder(date: fakeSelectedDate),
        ),
      ];
    },
    tearDown: () => createExpensesBloc.close(),
  );

  blocTest(
    'test create expenses item successfully',
    build: () => createExpensesBloc,
    act: (bloc) {
      bloc.add(CreateOrUpdateExpensesEvent.nameUpdated(
        name: fakeSelectedName,
      ));
      bloc.add(CreateOrUpdateExpensesEvent.amountUpdated(
        amount: fakeSelectedAmount.toString(),
      ));
      bloc.add(CreateOrUpdateExpensesEvent.dateUpdated(date: fakeSelectedDate));
      bloc.add(const CreateOrUpdateExpensesEvent.createOrUpdateExpenses());
    },
    expect: () {
      return <CreateOrUpdateExpensesState>[
        CreateOrUpdateExpensesState(name: fakeSelectedName),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
        ),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
          isValid: true,
          dateHolder: CreateOrUpdateExpensesDateHolder(date: fakeSelectedDate),
        ),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
          isValid: true,
          expensesSaved: true,
          dateHolder: CreateOrUpdateExpensesDateHolder(date: fakeSelectedDate),
        ),
      ];
    },
    tearDown: () => createExpensesBloc.close(),
  );

  blocTest(
    'test update expenses item successfully',
    build: () => updateExpensesBloc,
    setUp: () {
      when(getExpensesByIdUseCase.execute(getExpensesItemByIdUseCaseParams))
          .thenAnswer((_) async => Right(fakeExpensesModel));
    },
    act: (bloc) {
      bloc.add(const CreateOrUpdateExpensesEvent.initialized());
      bloc.add(const CreateOrUpdateExpensesEvent.createOrUpdateExpenses());
    },
    expect: () {
      return <CreateOrUpdateExpensesState>[
        const CreateOrUpdateExpensesState(
          dateHolder: CreateOrUpdateExpensesDateHolder(
            language: AppLanguage.english,
          ),
        ),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
          isValid: true,
          dateHolder: CreateOrUpdateExpensesDateHolder(
            date: fakeSelectedDate,
            language: AppLanguage.english,
          ),
        ),
        CreateOrUpdateExpensesState(
          name: fakeSelectedName,
          amount: fakeSelectedAmount,
          isValid: true,
          expensesSaved: true,
          dateHolder: CreateOrUpdateExpensesDateHolder(
            date: fakeSelectedDate,
            language: AppLanguage.english,
          ),
        ),
      ];
    },
    tearDown: () => updateExpensesBloc.close(),
  );
}
