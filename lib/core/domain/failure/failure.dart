import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_failure_reason.dart';
import 'reset_password_failure_reason.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.signInFailed({
    required AuthFailureReason reason,
  }) = _SignInFailed;

  const factory Failure.signUpFailed({
    required AuthFailureReason reason,
  }) = _SignUpFailed;

  const factory Failure.genericFailure() = _GenericFailure;

  const factory Failure.profileNotFound() = _ProfileNotFound;

  const factory Failure.resetPasswordFailure({
    required ResetPasswordFailureReason reason,
  }) = _ResetPasswordFailure;
}
