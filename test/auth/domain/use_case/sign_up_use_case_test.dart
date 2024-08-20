import 'package:expenses_tracker/auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_up_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late SignUpUseCase signUpUseCase;
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(authRepository);
  });

  test('test sign up returns user on success', () async {
    when(authRepository.createUserWithEmailAndPassword(fakeEmail, fakePassword))
        .thenAnswer((_) async => fakeUser);

    final result = await signUpUseCase.execute(fakeAuthUseCaseParams);

    expect(result.getRight().toNullable(), fakeUser);
  });

  test('test sign up returns failure on exception', () async {
    when(authRepository.createUserWithEmailAndPassword(fakeEmail, fakePassword))
        .thenThrow(FirebaseAuthException(code: codeEmailAlreadyInUse));

    final result = await signUpUseCase.execute(fakeAuthUseCaseParams);

    expect(
      result.getLeft().toNullable(),
      const Failure.signUpFailed(reason: AuthFailureReason.emailInUse()),
    );
  });
}
