import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure_reason.freezed.dart';

@freezed
class AuthFailureReason with _$AuthFailureReason {
  const factory AuthFailureReason.unknown() = _Unknown;

  const factory AuthFailureReason.passwordTooWeak() = _PasswordTooWeak;

  const factory AuthFailureReason.wrongPassword() = _WrongPassword;

  const factory AuthFailureReason.userNotFound() = _UserNotFound;

  const factory AuthFailureReason.emailInUse() = _EmailInUse;

  const factory AuthFailureReason.invalidCredential() = _InvalidCredential;

  const factory AuthFailureReason.accountAlreadyExistsWithDifferentCredentials() =
      _AccountAlreadyExistsWithDifferentCredentials;
}
