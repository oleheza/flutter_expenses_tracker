import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../../core/domain/failure/auth_failure_reason.dart';
import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/failure/reset_password_failure_reason.dart';

@visibleForTesting
const codeWeakPassword = 'weak-password';

@visibleForTesting
const codeEmailAlreadyInUse = 'email-already-in-use';

@visibleForTesting
const codeUserNotFound = 'user-not-found';

@visibleForTesting
const codeWrongPassword = 'wrong-password';

@visibleForTesting
const codeInvalidCredential = 'invalid-credential';

@visibleForTesting
const codeAccountAlreadyExistsWithDifferentCredentials =
    'account-exists-with-different-credential';

@visibleForTesting
const codeResetPasswordInvalidEmail = 'auth/invalid-email';

@visibleForTesting
const codeResetPasswordUserNotFound = 'auth/user-not-found';

mixin FirebaseAuthExceptionHandler {
  Failure handleSignUpException(FirebaseAuthException exception) {
    final reason = switch (exception.code) {
      codeWeakPassword => const AuthFailureReason.passwordTooWeak(),
      codeEmailAlreadyInUse => const AuthFailureReason.emailInUse(),
      _ => const AuthFailureReason.unknown()
    };

    return Failure.signUpFailed(reason: reason);
  }

  Failure handleSignInException(FirebaseAuthException exception) {
    final reason = switch (exception.code) {
      codeWrongPassword => const AuthFailureReason.wrongPassword(),
      codeUserNotFound => const AuthFailureReason.userNotFound(),
      codeInvalidCredential => const AuthFailureReason.invalidCredential(),
      codeAccountAlreadyExistsWithDifferentCredentials =>
        const AuthFailureReason.accountAlreadyExistsWithDifferentCredentials(),
      _ => const AuthFailureReason.unknown(),
    };

    return Failure.signInFailed(reason: reason);
  }

  Failure handleResetPasswordException(FirebaseAuthException exception) {
    final reason = switch (exception.code) {
      codeResetPasswordInvalidEmail =>
        const ResetPasswordFailureReason.invalidEmail(),
      codeResetPasswordUserNotFound =>
        const ResetPasswordFailureReason.userNotFound(),
      _ => const ResetPasswordFailureReason.unknown(),
    };

    return Failure.resetPasswordFailure(reason: reason);
  }
}
