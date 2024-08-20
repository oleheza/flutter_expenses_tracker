import 'package:expenses_tracker/auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/failure/reset_password_failure_reason.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_firebase_auth_exception_handler.dart';

void main() {
  late MockFirebaseAuthExceptionHandler firebaseAuthExceptionHandler =
      MockFirebaseAuthExceptionHandler();

  test('test firebase auth exception handler handles sign in codes properly',
      () {
    void expectProperFailureForCode(
      String code,
      AuthFailureReason authFailureReason,
    ) {
      expect(
          firebaseAuthExceptionHandler
              .handleSignInException(FirebaseAuthException(code: code)),
          Failure.signInFailed(reason: authFailureReason));
    }

    expectProperFailureForCode(
      codeWrongPassword,
      const AuthFailureReason.wrongPassword(),
    );

    expectProperFailureForCode(
      codeUserNotFound,
      const AuthFailureReason.userNotFound(),
    );

    expectProperFailureForCode(
      codeInvalidCredential,
      const AuthFailureReason.invalidCredential(),
    );

    expectProperFailureForCode(
      codeAccountAlreadyExistsWithDifferentCredentials,
      const AuthFailureReason.accountAlreadyExistsWithDifferentCredentials(),
    );

    expectProperFailureForCode(
      '',
      const AuthFailureReason.unknown(),
    );
  });

  test(
    'test firebase auth exception handler handles sign in codes properly',
    () {
      void expectProperFailureForCode(
        String code,
        AuthFailureReason authFailureReason,
      ) {
        expect(
            firebaseAuthExceptionHandler
                .handleSignUpException(FirebaseAuthException(code: code)),
            Failure.signUpFailed(reason: authFailureReason));
      }

      expectProperFailureForCode(
        codeWeakPassword,
        const AuthFailureReason.passwordTooWeak(),
      );

      expectProperFailureForCode(
        codeEmailAlreadyInUse,
        const AuthFailureReason.emailInUse(),
      );

      expectProperFailureForCode(
        '',
        const AuthFailureReason.unknown(),
      );
    },
  );

  test(
    'test firebase auth exception handler handles reset password codes properly',
    () {
      void expectProperFailureForCode(
        String code,
        ResetPasswordFailureReason reason,
      ) {
        expect(
            firebaseAuthExceptionHandler.handleResetPasswordException(
                FirebaseAuthException(code: code)),
            Failure.resetPasswordFailure(reason: reason));
      }

      expectProperFailureForCode(
        codeResetPasswordInvalidEmail,
        const ResetPasswordFailureReason.invalidEmail(),
      );

      expectProperFailureForCode(
        codeResetPasswordUserNotFound,
        const ResetPasswordFailureReason.userNotFound(),
      );

      expectProperFailureForCode(
        '',
        const ResetPasswordFailureReason.unknown(),
      );
    },
  );
}
