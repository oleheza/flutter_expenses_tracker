part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory ForgotPasswordEvent.onEmailChanged({
    required String? email,
  }) = _OnEmailChanged;

  const factory ForgotPasswordEvent.failureDismissed() = _FailureDismissed;

  const factory ForgotPasswordEvent.resetPassword() = _ResetPassword;
}
