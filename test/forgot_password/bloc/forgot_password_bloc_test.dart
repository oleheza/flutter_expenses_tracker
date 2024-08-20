import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/failure/reset_password_failure_reason.dart';
import 'package:expenses_tracker/core/domain/validator/validator.dart';
import 'package:expenses_tracker/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:expenses_tracker/forgot_password/domain/use_case/request_forgot_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import '../../mocks/use_case_mocks.mocks.dart';

void main() {
  late ForgotPasswordBloc bloc;
  late Validator validator;
  late RequestForgotPasswordUseCase forgotPasswordUseCase;

  const resetPasswordFailure = Failure.resetPasswordFailure(
    reason: ResetPasswordFailureReason.userNotFound(),
  );

  setUp(() {
    validator = Validator();
    forgotPasswordUseCase = MockRequestForgotPasswordUseCase();
    bloc = ForgotPasswordBloc(
      forgotPasswordUseCase: forgotPasswordUseCase,
      validator: validator,
    );
  });

  blocTest('test forgot password bloc emits correct state',
      build: () => bloc,
      setUp: () {
        provideDummy<Either<Failure, void>>(const Right(null));
      },
      act: (bloc) {
        bloc.add(const ForgotPasswordEvent.onEmailChanged(email: 'alex'));
        bloc.add(const ForgotPasswordEvent.onEmailChanged(email: fakeEmail));
        bloc.add(const ForgotPasswordEvent.resetPassword());
      },
      expect: () {
        return <ForgotPasswordState>[
          const ForgotPasswordState(email: 'alex'),
          const ForgotPasswordState(email: fakeEmail, isValid: true),
          const ForgotPasswordState(
            email: fakeEmail,
            isValid: true,
            isLoading: true,
          ),
          const ForgotPasswordState(
            email: fakeEmail,
            isValid: true,
            isLoading: false,
            passwordReset: true,
          )
        ];
      },
      tearDown: () => bloc.close());

  blocTest(
    'test failed forgot password emits correct state',
    build: () => bloc,
    setUp: () {
      provideDummy<Either<Failure, void>>(const Left(resetPasswordFailure));
      when(forgotPasswordUseCase.execute(fakeEmail))
          .thenAnswer((_) async => const Left(resetPasswordFailure));
    },
    act: (bloc) {
      bloc.add(const ForgotPasswordEvent.onEmailChanged(email: fakeEmail));
      bloc.add(const ForgotPasswordEvent.resetPassword());
    },
    expect: () {
      return <ForgotPasswordState>[
        const ForgotPasswordState(email: fakeEmail, isValid: true),
        const ForgotPasswordState(
            email: fakeEmail, isValid: true, isLoading: true),
        const ForgotPasswordState(
          failure: resetPasswordFailure,
          email: fakeEmail,
          isLoading: false,
          isValid: true,
        ),
      ];
    },
    tearDown: () => bloc.close(),
  );
}
