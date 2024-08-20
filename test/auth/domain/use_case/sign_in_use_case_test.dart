import 'package:expenses_tracker/auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late SignInUseCase signInUseCase;
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(authRepository);
  });

  test('test sign use case returns user on success', () async {
    when(authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    )).thenAnswer((_) async => fakeUser);

    final result = await signInUseCase.execute(fakeAuthUseCaseParams);

    verify(authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    )).called(1);
    expect(result.getRight().toNullable(), fakeUser);
  });

  test('test sign use case returns failure on exception', () async {
    when(authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    )).thenThrow(FirebaseAuthException(code: codeUserNotFound));

    final result = await signInUseCase.execute(fakeAuthUseCaseParams);

    verify(authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    )).called(1);
    expect(
      result.getLeft().toNullable(),
      const Failure.signInFailed(reason: AuthFailureReason.userNotFound()),
    );
  });
}
