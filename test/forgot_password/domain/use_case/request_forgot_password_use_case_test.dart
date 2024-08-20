import 'package:expenses_tracker/auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/forgot_password/domain/use_case/request_forgot_password_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late RequestForgotPasswordUseCase requestForgotPasswordUseCase;
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    requestForgotPasswordUseCase = RequestForgotPasswordUseCase(
      authRepository: authRepository,
    );
  });

  test('test successful password reset is correct', () async {
    provideDummy<Either<Failure, void>>(const Right(null));

    await requestForgotPasswordUseCase.execute(fakeEmail);
    verify(authRepository.resetPassword(fakeEmail)).called(1);
  });

  test('test failed reset password is correct', () async {
    when(authRepository.resetPassword(fakeEmail))
        .thenThrow(FirebaseAuthException(code: codeResetPasswordUserNotFound));

    final result = await requestForgotPasswordUseCase.execute(fakeEmail);

    expect(result.isLeft(), isTrue);
  });
}
