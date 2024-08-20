import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_failure_reason.freezed.dart';

@freezed
class ResetPasswordFailureReason with _$ResetPasswordFailureReason {
  const factory ResetPasswordFailureReason.invalidEmail() = _InvalidEmail;
  const factory ResetPasswordFailureReason.userNotFound() = _UserNotFound;
  const factory ResetPasswordFailureReason.unknown() = _Unknown;
}
