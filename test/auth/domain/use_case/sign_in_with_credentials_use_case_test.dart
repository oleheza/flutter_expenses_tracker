import 'package:expenses_tracker/auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_with_credentials_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import '../../../mocks/firebase_mocks.mocks.dart';

void main() {
  late FirebaseAuth firebaseAuth;
  late SignInWithCredentialsUseCase signInWithCredentialsUseCase;
  late MockAuthCredential mockAuthCredential;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    signInWithCredentialsUseCase = SignInWithCredentialsUseCase(firebaseAuth);
    mockAuthCredential = MockAuthCredential();
  });

  test('test sign in with credentials is success', () async {
    final result =
        await signInWithCredentialsUseCase.execute(mockAuthCredential);

    expect(result.isRight(), true);
  });

  test('test sign in with credentials returns failure on exception', () async {
    whenCalling(Invocation.method(#signInWithCredential, [mockAuthCredential]))
        .on(firebaseAuth)
        .thenThrow(FirebaseAuthException(code: codeUserNotFound));

    final result =
        await signInWithCredentialsUseCase.execute(mockAuthCredential);

    expect(
      result.getLeft().toNullable(),
      const Failure.signInFailed(reason: AuthFailureReason.userNotFound()),
    );
  });
}
